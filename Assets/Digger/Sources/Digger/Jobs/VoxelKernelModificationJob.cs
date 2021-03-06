﻿using System;
using Digger.TerrainCutters;
using Unity.Burst;
using Unity.Collections;
using Unity.Jobs;
using Unity.Mathematics;
using UnityEngine;

namespace Digger
{
    [BurstCompile(CompileSynchronously = true, FloatMode = FloatMode.Fast)]
    public struct VoxelKernelModificationJob : IJobParallelFor
    {
        public int SizeVox;
        public int SizeOfMesh;
        public int SizeVox2;
        public int LowInd;
        public ActionType Action;
        public float3 HeightmapScale;
        public float3 Center;
        public float Radius;
        public float RadiusWithMargin;
        public float Intensity;

        public int ChunkAltitude;
        public int2 CutSize;
        public float2 TerrainRelativePositionToHolePosition;
        public float3 WorldPosition;
        public sbyte TextureIndex;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> Voxels;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<float> Heights;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<float> VerticalNormals;

        [WriteOnly] public NativeArray<Voxel> VoxelsOut;

        // Smooth action only
        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsLBB;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsLBF;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsLB_;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxels_BB;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxels_BF;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxels_B_;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsRBB;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsRBF;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsRB_;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsL_B;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsL_F;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsL__;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxels__B;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxels__F;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsR_B;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsR_F;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsR__;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsLUB;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsLUF;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsLU_;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxels_UB;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxels_UF;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxels_U_;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsRUB;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsRUF;

        [ReadOnly] [NativeDisableParallelForRestriction]
        public NativeArray<Voxel> NeighborVoxelsRU_;

        [WriteOnly] public NativeCollections.NativeQueue<CutEntry>.Concurrent ToCut;
#if !UNITY_2019_3_OR_NEWER
        [WriteOnly] public NativeCollections.NativeQueue<float3>.Concurrent ToTriggerBounds;
#endif

        public void Execute(int index)
        {
            var xi = index / SizeVox2;
            var yi = (index - xi * SizeVox2) / SizeVox;
            var zi = index - xi * SizeVox2 - yi * SizeVox;

            var p = new float3((xi - 1) * HeightmapScale.x, (yi - 1), (zi - 1) * HeightmapScale.z);
            var terrainHeight = Heights[xi * SizeVox + zi];
            var terrainHeightValue = p.y + ChunkAltitude - terrainHeight;

            // Always use a spherical brush
            var distances = ComputeSphereDistances(p);

            Voxel voxel;
            switch (Action) {
                case ActionType.Smooth:
                    voxel = ApplySmooth(index, xi, yi, zi, distances.x, distances.y, terrainHeightValue);
                    break;
                case ActionType.BETA_Sharpen:
                    voxel = ApplySharpen(index, xi, yi, zi, distances.x, distances.y, terrainHeightValue);
                    break;
                default:
                    return; // never happens
            }

            if (voxel.Altered != 0) {
                var absAltered = Math.Abs(voxel.Altered);
                if (Math.Abs(terrainHeightValue) <= 1f && Math.Abs(voxel.Value - terrainHeightValue) < 0.08f) {
                    absAltered = 1;
                } else if (absAltered >= Voxel.TextureOffset) {
                    var terrainNrm = VerticalNormals[xi * SizeVox + zi];
                    if (Math.Abs(terrainHeightValue) <= 1f / Math.Max(terrainNrm, 0.001f) + 0.5f) {
                        absAltered = (sbyte) (absAltered - Voxel.TextureOffset + Voxel.TextureNearSurfaceOffset);
                    }
                }

                if (voxel.Value > terrainHeightValue) {
                    voxel.Altered = (sbyte) -absAltered;
                } else {
                    voxel.Altered = absAltered;
                }
            }

            if (voxel.IsAlteredNearBelowSurface || voxel.IsAlteredNearAboveSurface) {
                var pos = new float3((xi - 1) * HeightmapScale.x, (yi - 1), (zi - 1) * HeightmapScale.z);
#if !UNITY_2019_3_OR_NEWER
                ToTriggerBounds.Enqueue(pos);
#endif
                var wpos = pos + WorldPosition;
                var pCut = new int3((int) (wpos.x * TerrainRelativePositionToHolePosition.x), (int) wpos.y, (int) (wpos.z * TerrainRelativePositionToHolePosition.y));
                for (var x = -CutSize.x; x < CutSize.x; ++x) {
                    for (var z = -CutSize.y; z < CutSize.y; ++z) {
                        ToCut.Enqueue(new CutEntry(
                                          pCut.x + x,
                                          pCut.z + z,
                                          voxel.IsAlteredNearAboveSurface
                                      ));
                    }
                }
            }

            VoxelsOut[index] = voxel;
        }

        public void DisposeNeighbors()
        {
            NeighborVoxelsLBB.Dispose();
            NeighborVoxelsLBF.Dispose();
            NeighborVoxelsLB_.Dispose();
            NeighborVoxels_BB.Dispose();
            NeighborVoxels_BF.Dispose();
            NeighborVoxels_B_.Dispose();
            NeighborVoxelsRBB.Dispose();
            NeighborVoxelsRBF.Dispose();
            NeighborVoxelsRB_.Dispose();
            NeighborVoxelsL_B.Dispose();
            NeighborVoxelsL_F.Dispose();
            NeighborVoxelsL__.Dispose();
            NeighborVoxels__B.Dispose();
            NeighborVoxels__F.Dispose();
            NeighborVoxelsR_B.Dispose();
            NeighborVoxelsR_F.Dispose();
            NeighborVoxelsR__.Dispose();
            NeighborVoxelsLUB.Dispose();
            NeighborVoxelsLUF.Dispose();
            NeighborVoxelsLU_.Dispose();
            NeighborVoxels_UB.Dispose();
            NeighborVoxels_UF.Dispose();
            NeighborVoxels_U_.Dispose();
            NeighborVoxelsRUB.Dispose();
            NeighborVoxelsRUF.Dispose();
            NeighborVoxelsRU_.Dispose();
        }

        private float2 ComputeSphereDistances(float3 p)
        {
            var vec = p - Center;
            var distance = (float) Math.Sqrt(vec.x * vec.x + vec.y * vec.y + vec.z * vec.z);
            var flatDistance = (float) Math.Sqrt(vec.x * vec.x + vec.z * vec.z);
            return new float2(Radius - distance, RadiusWithMargin - flatDistance);
        }

        private Voxel ApplySmooth(int index, int xi, int yi, int zi, float distance, float flatDistance, float terrainHeightValue)
        {
            var voxel = Voxels[index];

            var voxelValue = 0f;
            var absAlteredNeighbour = 0;
            for (var x = xi - 1; x <= xi + 1; ++x) {
                for (var y = yi - 1; y <= yi + 1; ++y) {
                    for (var z = zi - 1; z <= zi + 1; ++z) {
                        var vox = GetVoxelAt(x, y, z);
                        voxelValue += vox.Value;
                        if (Math.Abs(vox.Altered) > absAlteredNeighbour)
                            absAlteredNeighbour = Math.Abs(vox.Altered);
                    }
                }
            }
            
            if (voxel.IsAlteredOrNearSurface)
                absAlteredNeighbour = Math.Abs(voxel.Altered);
            
            if (absAlteredNeighbour <= 1)
                return ComputeUnaltered(flatDistance, voxel);
            
            if (Math.Abs(terrainHeightValue) <= 4f && Math.Abs(voxelValue - terrainHeightValue) < 0.4f)
                return ComputeUnaltered(flatDistance, voxel);

            const float by27 = 1f / 27f;
            return ComputeAltered(distance, flatDistance, voxel, voxelValue * by27, absAlteredNeighbour);
        }
        
        private Voxel ApplySharpen(int index, int xi, int yi, int zi, float distance, float flatDistance, float terrainHeightValue)
        {
            var voxel = Voxels[index];
            if (Math.Abs(voxel.Altered) <= 1)
                return voxel;

            var voxelValue = 0f;
            var absAlteredNeighbour = 0;
            voxelValue += VoxelValue(xi - 1, yi, zi, -1f, ref absAlteredNeighbour);
            voxelValue += VoxelValue(xi + 1, yi, zi, -1f, ref absAlteredNeighbour);
            voxelValue += VoxelValue(xi, yi - 1, zi, -1f, ref absAlteredNeighbour);
            voxelValue += VoxelValue(xi, yi + 1, zi, -1f, ref absAlteredNeighbour);
            voxelValue += VoxelValue(xi, yi, zi - 1, -1f, ref absAlteredNeighbour);
            voxelValue += VoxelValue(xi, yi, zi + 1, -1f, ref absAlteredNeighbour);
            voxelValue += voxel.Value * 7f;
            
            if (voxel.IsAlteredOrNearSurface)
                absAlteredNeighbour = Math.Abs(voxel.Altered);

            if (Math.Abs(terrainHeightValue) <= 4f && Math.Abs(voxelValue - terrainHeightValue) < 0.4f)
                return ComputeUnaltered(flatDistance, voxel);

            if (absAlteredNeighbour <= 1 || voxelValue <= 0f && voxel.Value >= 0f || voxelValue >= 0f && voxel.Value <= 0f || Math.Abs(voxelValue) < 0.001f || Math.Abs(voxelValue) > Math.Max(Math.Abs(voxel.Value)*2, 4f))
                return ComputeUnaltered(flatDistance, voxel);
            
            return ComputeAltered(distance, flatDistance, voxel, voxelValue, absAlteredNeighbour);
        }

        private float VoxelValue(int x, int y, int z, float weight, ref int absAlteredNeighbour)
        {
            var vox = GetVoxelAt(x, y, z);
            if (Math.Abs(vox.Altered) > absAlteredNeighbour)
                absAlteredNeighbour = Math.Abs(vox.Altered);
            return weight * vox.Value;
        }

        private Voxel ComputeAltered(float distance, float flatDistance, Voxel voxel, float voxelValue, int absAlteredNeighbour)
        {
            if (distance >= 0) {
                voxel.Value = Mathf.Lerp(voxel.Value, voxelValue, Intensity);
                if (absAlteredNeighbour >= Voxel.TextureNearSurfaceOffset && absAlteredNeighbour < Voxel.TextureOffset) {
                    absAlteredNeighbour = absAlteredNeighbour - Voxel.TextureNearSurfaceOffset + Voxel.TextureOffset;
                }

                voxel.Altered = (sbyte) (absAlteredNeighbour);
                
            } else if (flatDistance > 0 && Math.Abs(voxel.Altered) < 3) {
                voxel.Altered = 1;
            }

            return voxel;
        }
        
        private Voxel ComputeUnaltered(float flatDistance, Voxel voxel)
        {
            if (flatDistance > 0 && Math.Abs(voxel.Altered) < 3) {
                voxel.Altered = 1;
            }

            return voxel;
        }

        private Voxel GetVoxelAt(int x, int y, int z)
        {
            // [x * SizeVox * SizeVox + y * SizeVox + z]
            if (x == -1) {
                if (y == -1) {
                    if (z == -1) {
                        return GetSafe(NeighborVoxelsLBB, LowInd * SizeVox2 + LowInd * SizeVox + LowInd);
                    } else if (z > SizeOfMesh) {
                        return GetSafe(NeighborVoxelsLBF, LowInd * SizeVox2 + LowInd * SizeVox + (z - SizeOfMesh));
                    } else {
                        return GetSafe(NeighborVoxelsLB_, LowInd * SizeVox2 + LowInd * SizeVox + z);
                    }
                } else if (y > SizeOfMesh) {
                    if (z == -1) {
                        return GetSafe(NeighborVoxelsLUB, LowInd * SizeVox2 + (y - SizeOfMesh) * SizeVox + LowInd);
                    } else if (z > SizeOfMesh) {
                        return GetSafe(NeighborVoxelsLUF, LowInd * SizeVox2 + (y - SizeOfMesh) * SizeVox + (z - SizeOfMesh));
                    } else {
                        return GetSafe(NeighborVoxelsLU_, LowInd * SizeVox2 + (y - SizeOfMesh) * SizeVox + z);
                    }
                } else {
                    if (z == -1) {
                        return GetSafe(NeighborVoxelsL_B, LowInd * SizeVox2 + y * SizeVox + LowInd);
                    } else if (z > SizeOfMesh) {
                        return GetSafe(NeighborVoxelsL_F, LowInd * SizeVox2 + y * SizeVox + (z - SizeOfMesh));
                    } else {
                        return GetSafe(NeighborVoxelsL__, LowInd * SizeVox2 + y * SizeVox + z);
                    }
                }
            } else if (x > SizeOfMesh) {
                if (y == -1) {
                    if (z == -1) {
                        return GetSafe(NeighborVoxelsRBB, (x - SizeOfMesh) * SizeVox2 + LowInd * SizeVox + LowInd);
                    } else if (z > SizeOfMesh) {
                        return GetSafe(NeighborVoxelsRBF, (x - SizeOfMesh) * SizeVox2 + LowInd * SizeVox + (z - SizeOfMesh));
                    } else {
                        return GetSafe(NeighborVoxelsRB_, (x - SizeOfMesh) * SizeVox2 + LowInd * SizeVox + z);
                    }
                } else if (y > SizeOfMesh) {
                    if (z == -1) {
                        return GetSafe(NeighborVoxelsRUB, (x - SizeOfMesh) * SizeVox2 + (y - SizeOfMesh) * SizeVox + LowInd);
                    } else if (z > SizeOfMesh) {
                        return GetSafe(NeighborVoxelsRUF, (x - SizeOfMesh) * SizeVox2 + (y - SizeOfMesh) * SizeVox + (z - SizeOfMesh));
                    } else {
                        return GetSafe(NeighborVoxelsRU_, (x - SizeOfMesh) * SizeVox2 + (y - SizeOfMesh) * SizeVox + z);
                    }
                } else {
                    if (z == -1) {
                        return GetSafe(NeighborVoxelsR_B, (x - SizeOfMesh) * SizeVox2 + y * SizeVox + LowInd);
                    } else if (z > SizeOfMesh) {
                        return GetSafe(NeighborVoxelsR_F, (x - SizeOfMesh) * SizeVox2 + y * SizeVox + (z - SizeOfMesh));
                    } else {
                        return GetSafe(NeighborVoxelsR__, (x - SizeOfMesh) * SizeVox2 + y * SizeVox + z);
                    }
                }
            } else {
                if (y == -1) {
                    if (z == -1) {
                        return GetSafe(NeighborVoxels_BB, x * SizeVox2 + LowInd * SizeVox + LowInd);
                    } else if (z > SizeOfMesh) {
                        return GetSafe(NeighborVoxels_BF, x * SizeVox2 + LowInd * SizeVox + (z - SizeOfMesh));
                    } else {
                        return GetSafe(NeighborVoxels_B_, x * SizeVox2 + LowInd * SizeVox + z);
                    }
                } else if (y > SizeOfMesh) {
                    if (z == -1) {
                        return GetSafe(NeighborVoxels_UB, x * SizeVox2 + (y - SizeOfMesh) * SizeVox + LowInd);
                    } else if (z > SizeOfMesh) {
                        return GetSafe(NeighborVoxels_UF, x * SizeVox2 + (y - SizeOfMesh) * SizeVox + (z - SizeOfMesh));
                    } else {
                        return GetSafe(NeighborVoxels_U_, x * SizeVox2 + (y - SizeOfMesh) * SizeVox + z);
                    }
                } else {
                    if (z == -1) {
                        return GetSafe(NeighborVoxels__B, x * SizeVox2 + y * SizeVox + LowInd);
                    } else if (z > SizeOfMesh) {
                        return GetSafe(NeighborVoxels__F, x * SizeVox2 + y * SizeVox + (z - SizeOfMesh));
                    } else {
                        return Voxels[x * SizeVox2 + y * SizeVox + z];
                    }
                }
            }
        }

        private Voxel GetSafe(NativeArray<Voxel> array, int index)
        {
            if (array.Length > 1) {
                return array[index];
            }

            return new Voxel();
        }

        private Voxel GetVoxelAtDebug(int x, int y, int z)
        {
            x = Mathf.Max(0, Mathf.Min(x, LowInd));
            y = Mathf.Max(0, Mathf.Min(y, LowInd));
            z = Mathf.Max(0, Mathf.Min(z, LowInd));
            return Voxels[x * SizeVox2 + y * SizeVox + z];
        }
    }
}