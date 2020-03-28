// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "D2 EnemyRace Shader 1.0.1"
//Made by TheJudSub on discord and xbox
//Please do not repost these shaders anywhere
//uploaded by Thejudsub on May 16th
{
	Properties
	{
		_DiffuseTexture("Diffuse Texture", 2D) = "black" {}
		[Toggle]_InvertdyemaskDiffusesAlphaChannel("Invert dyemask (Diffuse's Alpha Channel)", Float) = 0
		_MRCTexture("MRC Texture", 2D) = "black" {}
		[Toggle]_InvertdyemaskMRCsAlphaChannel("Invert dyemask (MRC's Alpha Channel)", Float) = 1
		_NormalMap("Normal Map", 2D) = "bump" {}
		_DyeMaskoptional("Dye Mask(optional)", 2D) = "white" {}
		_EmissionAmount("Emission Amount", Float) = 0
		_EmissionColor("Emission Color", Color) = (1,1,1,0)
		_TransparencyAmount("Transparency Amount", Range( 0 , 1)) = 0
		_CustomColor01("Custom Color 01", Color) = (1,0,0,0)
		_CustomColor02("Custom Color 02", Color) = (0,1,0,0)
		_CustomColor03("Custom Color 03", Color) = (0,0,1,0)
		_CustomColor04("Custom Color 04", Color) = (0,0,0,0)
		_DyemaskColor01diffusetexture("Dyemask Color 01 (diffuse texture)", Color) = (0,0.8235294,1,0)
		_DyemaskColor03MRCAlphaMask("Dyemask Color 03 (MRC Alpha Mask)", Color) = (1,0,0.977,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Background+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull Off
		Blend One OneMinusSrcAlpha , SrcAlpha OneMinusSrcAlpha
		BlendOp Add , Add
		AlphaToMask On
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		struct Input
		{
			float2 uv_texcoord;
		};

		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float4 _DyemaskColor03MRCAlphaMask;
		uniform sampler2D _DiffuseTexture;
		uniform float4 _DiffuseTexture_ST;
		uniform float4 _DyemaskColor01diffusetexture;
		uniform float4 _CustomColor01;
		uniform float4 _CustomColor02;
		uniform float4 _CustomColor03;
		uniform float4 _CustomColor04;
		uniform sampler2D _DyeMaskoptional;
		uniform float4 _DyeMaskoptional_ST;
		uniform float _InvertdyemaskDiffusesAlphaChannel;
		uniform float _InvertdyemaskMRCsAlphaChannel;
		uniform sampler2D _MRCTexture;
		uniform float4 _MRCTexture_ST;
		uniform float4 _EmissionColor;
		uniform float _EmissionAmount;
		uniform half _TransparencyAmount;


		float3 RGBToHSV(float3 c)
		{
			float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
			float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
			float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
			float d = q.x - min( q.w, q.y );
			float e = 1.0e-10;
			return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			float3 tex2DNode3 = UnpackNormal( tex2D( _NormalMap, uv_NormalMap ) );
			float4 appendResult302 = (float4(tex2DNode3.r , -tex2DNode3.g , tex2DNode3.b , 0.0));
			o.Normal = appendResult302.xyz;
			float2 uv_DiffuseTexture = i.uv_texcoord * _DiffuseTexture_ST.xy + _DiffuseTexture_ST.zw;
			float4 tex2DNode2 = tex2D( _DiffuseTexture, uv_DiffuseTexture );
			float4 blendOpSrc233 = _DyemaskColor03MRCAlphaMask;
			float4 blendOpDest233 = tex2DNode2;
			float4 blendOpSrc209 = _DyemaskColor01diffusetexture;
			float4 blendOpDest209 = tex2DNode2;
			float4 color226 = IsGammaSpace() ? float4(0.5019608,0.5019608,0.5019608,0) : float4(0.2158605,0.2158605,0.2158605,0);
			float4 blendOpSrc261 = color226;
			float4 blendOpDest261 = tex2DNode2;
			float4 temp_cast_1 = (0.0).xxxx;
			float4 blendOpSrc180 = _CustomColor01;
			float4 blendOpDest180 = tex2DNode2;
			float4 color35 = IsGammaSpace() ? float4(0,1,0,0) : float4(0,1,0,0);
			float4 color34 = IsGammaSpace() ? float4(1,0,0,0) : float4(1,0,0,0);
			float temp_output_22_0 =  ( i.uv_texcoord.x - 0.0 > 0.0 ? 0.0 : i.uv_texcoord.x - 0.0 <= 0.0 && i.uv_texcoord.x + 0.0 >= 0.0 ? 0.0 : 1.0 ) ;
			float clampResult78 = clamp( temp_output_22_0 , 0.0 , 1.0 );
			float temp_output_25_0 =  ( i.uv_texcoord.y - 0.0 > 0.0 ? 0.0 : i.uv_texcoord.y - 0.0 <= 0.0 && i.uv_texcoord.y + 0.0 >= 0.0 ? 0.0 : 1.0 ) ;
			float temp_output_80_0 = ( clampResult78 * ( 1.0 - temp_output_25_0 ) );
			float4 lerpResult33 = lerp( color35 , color34 , temp_output_80_0);
			float4 color37 = IsGammaSpace() ? float4(0,0,1,0) : float4(0,0,1,0);
			float4 lerpResult36 = lerp( lerpResult33 , color37 , ( temp_output_22_0 - temp_output_80_0 ));
			float4 color39 = IsGammaSpace() ? float4(0,0,0,0) : float4(0,0,0,0);
			float4 lerpResult38 = lerp( lerpResult36 , color39 , ( temp_output_25_0 - clampResult78 ));
			float clampResult89 = clamp(  ( i.uv_texcoord.x - 0.0 > 0.0 ? 1.0 : i.uv_texcoord.x - 0.0 <= 0.0 && i.uv_texcoord.x + 0.0 >= 0.0 ? 0.0 : 0.0 )  , 0.0 , 1.0 );
			float clampResult92 = clamp(  ( i.uv_texcoord.y - 0.0 > 1.0 ? 0.0 : i.uv_texcoord.y - 0.0 <= 1.0 && i.uv_texcoord.y + 0.0 >= 1.0 ? 0.0 : 1.0 )  , 0.0 , 1.0 );
			float clampResult93 = clamp( ( clampResult89 - clampResult92 ) , 0.0 , 1.0 );
			float4 lerpResult94 = lerp( lerpResult38 , color39 , clampResult93);
			float clampResult103 = clamp( (  ( i.uv_texcoord.x - 0.0 > 0.0 ? 0.0 : i.uv_texcoord.x - 0.0 <= 0.0 && i.uv_texcoord.x + 0.0 >= 0.0 ? 0.0 : 1.0 )  -  ( i.uv_texcoord.y - 0.0 > 1.0 ? 0.0 : i.uv_texcoord.y - 0.0 <= 1.0 && i.uv_texcoord.y + 0.0 >= 1.0 ? 0.0 : 1.0 )  ) , 0.0 , 1.0 );
			float4 lerpResult104 = lerp( lerpResult94 , color37 , clampResult103);
			float clampResult112 = clamp( (  ( i.uv_texcoord.x - 0.0 > 1.0 ? 1.0 : i.uv_texcoord.x - 0.0 <= 1.0 && i.uv_texcoord.x + 0.0 >= 1.0 ? 0.0 : 0.0 )  -  ( i.uv_texcoord.y - 0.0 > 0.0 ? 0.0 : i.uv_texcoord.y - 0.0 <= 0.0 && i.uv_texcoord.y + 0.0 >= 0.0 ? 0.0 : 1.0 )  ) , 0.0 , 1.0 );
			float4 lerpResult113 = lerp( lerpResult104 , color34 , clampResult112);
			float clampResult121 = clamp( (  ( i.uv_texcoord.x - 0.0 > 1.0 ? 1.0 : i.uv_texcoord.x - 0.0 <= 1.0 && i.uv_texcoord.x + 0.0 >= 1.0 ? 0.0 : 0.0 )  -  ( i.uv_texcoord.y - 0.0 > 1.0 ? 0.0 : i.uv_texcoord.y - 0.0 <= 1.0 && i.uv_texcoord.y + 0.0 >= 1.0 ? 0.0 : 1.0 )  ) , 0.0 , 1.0 );
			float4 lerpResult122 = lerp( lerpResult113 , color37 , clampResult121);
			float clampResult131 = clamp( (  ( i.uv_texcoord.y - 0.0 > 0.0 ? 0.0 : i.uv_texcoord.y - 0.0 <= 0.0 && i.uv_texcoord.y + 0.0 >= 0.0 ? 0.0 : 1.0 )  -  ( i.uv_texcoord.x - 0.0 > 1.0 ? 0.0 : i.uv_texcoord.x - 0.0 <= 1.0 && i.uv_texcoord.x + 0.0 >= 1.0 ? 0.0 : 1.0 )  ) , 0.0 , 1.0 );
			float4 lerpResult130 = lerp( lerpResult122 , color37 , clampResult131);
			float4 break134 = saturate( lerpResult130 );
			float4 lerpResult165 = lerp( temp_cast_1 , ( saturate( (( blendOpDest180 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest180 - 0.5 ) ) * ( 1.0 - blendOpSrc180 ) ) : ( 2.0 * blendOpDest180 * blendOpSrc180 ) ) )) , break134.r);
			float4 blendOpSrc179 = _CustomColor02;
			float4 blendOpDest179 = tex2DNode2;
			float4 lerpResult183 = lerp( lerpResult165 , ( saturate( (( blendOpDest179 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest179 - 0.5 ) ) * ( 1.0 - blendOpSrc179 ) ) : ( 2.0 * blendOpDest179 * blendOpSrc179 ) ) )) , break134.g);
			float4 blendOpSrc181 = _CustomColor03;
			float4 blendOpDest181 = tex2DNode2;
			float4 lerpResult184 = lerp( lerpResult183 , ( saturate( (( blendOpDest181 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest181 - 0.5 ) ) * ( 1.0 - blendOpSrc181 ) ) : ( 2.0 * blendOpDest181 * blendOpSrc181 ) ) )) , break134.b);
			float4 blendOpSrc182 = _CustomColor04;
			float4 blendOpDest182 = tex2DNode2;
			float3 hsvTorgb148 = RGBToHSV( lerpResult130.rgb );
			float4 lerpResult239 = lerp( lerpResult184 , ( saturate( (( blendOpDest182 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest182 - 0.5 ) ) * ( 1.0 - blendOpSrc182 ) ) : ( 2.0 * blendOpDest182 * blendOpSrc182 ) ) )) ,  ( 0.0 - 0.0 > hsvTorgb148.y ? 0.0 : 0.0 - 0.0 <= hsvTorgb148.y && 0.0 + 0.0 >= hsvTorgb148.y ? 1.0 : 0.0 ) );
			float2 uv_DyeMaskoptional = i.uv_texcoord * _DyeMaskoptional_ST.xy + _DyeMaskoptional_ST.zw;
			float4 lerpResult260 = lerp( ( saturate( (( blendOpDest261 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest261 - 0.5 ) ) * ( 1.0 - blendOpSrc261 ) ) : ( 2.0 * blendOpDest261 * blendOpSrc261 ) ) )) , lerpResult239 , saturate( tex2D( _DyeMaskoptional, uv_DyeMaskoptional ).r ));
			float4 lerpResult262 = lerp( ( saturate( (( blendOpDest209 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest209 - 0.5 ) ) * ( 1.0 - blendOpSrc209 ) ) : ( 2.0 * blendOpDest209 * blendOpSrc209 ) ) )) , lerpResult260 , lerp(( 1.0 - tex2DNode2.a ),tex2DNode2.a,_InvertdyemaskDiffusesAlphaChannel));
			float2 uv_MRCTexture = i.uv_texcoord * _MRCTexture_ST.xy + _MRCTexture_ST.zw;
			float4 tex2DNode1 = tex2D( _MRCTexture, uv_MRCTexture );
			float4 lerpResult280 = lerp( ( saturate( (( blendOpDest233 > 0.5 ) ? ( 1.0 - ( 1.0 - 2.0 * ( blendOpDest233 - 0.5 ) ) * ( 1.0 - blendOpSrc233 ) ) : ( 2.0 * blendOpDest233 * blendOpSrc233 ) ) )) , lerpResult262 , lerp(tex2DNode1.a,( 1.0 - tex2DNode1.a ),_InvertdyemaskMRCsAlphaChannel));
			o.Albedo = lerpResult280.rgb;
			float4 temp_cast_4 = (( tex2DNode2.a * _EmissionAmount )).xxxx;
			float4 blendOpSrc296 = _EmissionColor;
			float4 blendOpDest296 = temp_cast_4;
			o.Emission = ( saturate( ( 1.0 - ( ( 1.0 - blendOpDest296) / blendOpSrc296) ) )).rgb;
			o.Metallic = tex2DNode1.r;
			o.Smoothness = tex2DNode1.g;
			o.Occlusion = tex2DNode1.b;
			float clampResult14 = clamp( ( tex2DNode2.a + ( ( _TransparencyAmount + -1.0 ) * -1.0 ) ) , 0.0 , 1.0 );
			o.Alpha = clampResult14;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			AlphaToMask Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				float4 tSpace0 : TEXCOORD3;
				float4 tSpace1 : TEXCOORD4;
				float4 tSpace2 : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16400
200;29;1267;1004;1669.202;-237.0731;3.687577;True;True
Node;AmplifyShaderEditor.CommentaryNode;73;-2120.854,1369.922;Float;False;2258.125;3093.878;4way switch dye system;36;299;131;129;121;112;120;103;111;102;123;124;93;114;88;115;31;105;108;89;32;92;80;96;99;81;78;83;91;90;85;61;19;40;41;300;301;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;41;-1704.199,1653.619;Float;False;428.9149;251.7827;Lessthan;2;25;26;;0.09019608,0.09019608,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;40;-1696.247,1400.427;Float;False;418.7758;244.9536;Lessthan;2;22;23;;0,0,1,1;0;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-2112.139,1406.594;Float;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;23;-1680.248,1494.729;Float;False;Constant;_Float4;Float 4;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;61;-2103.355,2108.321;Float;False;Constant;_WhiteValue;White Value;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;26;-1687.2,1747.862;Float;False;Constant;_LessThan;LessThan;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;91;-2086.982,3331.375;Float;False;Constant;_Clamp1;Clamp 1;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-2087.928,3229.677;Float;False;Constant;_Clamp0;Clamp0;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;25;-1507.021,1703.619;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;85;-1701.004,2162.329;Float;False;428.9149;251.7827;Lessthan;2;87;86;;0.2705882,0.2705882,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;83;-1702.977,1907.929;Float;False;428.9149;251.7827;Greaterthan;2;84;82;;0.1803922,0.1803922,1,1;0;0
Node;AmplifyShaderEditor.TFHCIf;22;-1503.518,1450.427;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;301;-870.7609,1421.869;Float;False;463.3394;783.3551;RGB+Black Mask color Assignment;8;35;33;36;34;37;39;94;38;;0,0,0,1;0;0
Node;AmplifyShaderEditor.OneMinusNode;81;-1265.921,1654.191;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-1684.005,2256.571;Float;False;Constant;_Lessthan;Lessthan;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;78;-1274.635,1403.535;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;82;-1685.978,2002.172;Float;False;Constant;_GreaterThan;GreaterThan;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;35;-855.9276,1463.035;Float;False;Constant;_Color2;Color 2;6;0;Create;True;0;0;False;0;0,1,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;34;-856.2787,1652.361;Float;False;Constant;_Color1;Color 1;6;0;Create;True;0;0;False;0;1,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;96;-1702.246,2419.853;Float;False;428.9149;251.7827;Lessthan;2;98;97;;0.3607843,0.3607843,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;99;-1699.971,2674.1;Float;False;428.9149;251.7827;Lessthan;2;101;100;;0.4509804,0.4509804,1,1;0;0
Node;AmplifyShaderEditor.TFHCIf;84;-1505.799,1957.929;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-1108.939,1402.196;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;87;-1503.826,2212.328;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;97;-1685.247,2514.095;Float;False;Constant;_Float5;Float 5;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;32;-1111.384,1490.29;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;33;-559.1329,1464.401;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;37;-855.0974,1842.292;Float;False;Constant;_Color3;Color 3;6;0;Create;True;0;0;False;0;0,0,1,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;108;-1695.329,3183.085;Float;False;428.9149;251.7827;Lessthan;2;110;109;;0.6313726,0.6313726,1,1;0;0
Node;AmplifyShaderEditor.ClampOpNode;89;-1270.109,1908.288;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;101;-1682.972,2768.342;Float;False;Constant;_Float10;Float 10;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;92;-1269.928,2163.245;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;105;-1697.907,2928.987;Float;False;428.9149;251.7827;Greaterthan;2;107;106;;0.5411765,0.5411765,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;115;-1695.02,3437.073;Float;False;428.9149;251.7827;Lessthan;2;118;116;;0.7215686,0.7215686,1,1;0;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;88;-1127.771,1907.788;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;100;-1506.004,2727.309;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;109;-1678.331,3277.326;Float;False;Constant;_Float8;Float 8;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;36;-556.4782,1648.462;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCIf;98;-1505.068,2469.852;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;31;-1267.917,1722.941;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;39;-853.4639,2027.168;Float;False;Constant;_Color4;Color 4;6;0;Create;True;0;0;False;0;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;114;-1694.072,3691.907;Float;False;428.9149;251.7827;Lessthan;2;119;117;;0.8117647,0.8117647,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;106;-1694.599,3050.61;Float;False;Constant;_Float7;Float 7;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;93;-1124.188,1997.1;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;116;-1691.712,3558.695;Float;False;Constant;_Float12;Float 12;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;110;-1501.362,3236.294;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;38;-555.9684,1839.826;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;124;-1694.989,3944.798;Float;False;428.9149;251.7827;Lessthan;2;127;126;;0.9019608,0.9019608,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;117;-1677.074,3786.148;Float;False;Constant;_Float13;Float 13;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;102;-1267.863,2583.841;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;123;-1694.045,4198.571;Float;False;428.9149;251.7827;Lessthan;2;128;125;;0.9921569,0.9921569,1,1;0;0
Node;AmplifyShaderEditor.TFHCIf;107;-1503.94,2982.196;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;125;-1677.046,4292.811;Float;False;Constant;_Float14;Float 14;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;111;-1262.464,3097.498;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;103;-1266.892,2672.189;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;94;-558.0049,2024.732;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCIf;119;-1500.106,3745.116;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;118;-1501.053,3490.282;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-1691.681,4066.42;Float;False;Constant;_Float15;Float 15;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;300;-247.4312,1402.716;Float;False;373.6446;543.48;RGB+Black mask merge;5;104;113;122;130;259;;0,0.4206896,1,1;0;0
Node;AmplifyShaderEditor.TFHCIf;127;-1501.022,3998.006;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;104;-212.219,1437.313;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;120;-1261.787,3605.138;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;128;-1500.078,4251.779;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;112;-1263.519,3182.994;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;113;-211.1228,1548.216;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;121;-1258.634,3692.083;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;129;-1262.638,4111.071;Float;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;122;-209.6262,1659.334;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;131;-1262.072,4198.713;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;298;144.938,1370.286;Float;False;1497.051;1196.034;Dye Application;26;280;233;262;281;191;234;209;282;260;241;283;261;204;239;226;184;182;167;181;183;179;165;144;180;140;136;;0,1,0.006896496,1;0;0
Node;AmplifyShaderEditor.LerpOp;130;-210.2493,1774.793;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;17;176.0039,2943.514;Float;False;835.6682;330.7;Transparency Bias;9;13;9;16;15;14;10;11;12;7;;0,0.7931032,1,1;0;0
Node;AmplifyShaderEditor.SaturateNode;259;-60.76682,1780.99;Float;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-1557.883,631.3285;Float;True;Property;_DiffuseTexture;Diffuse Texture;0;0;Create;True;0;0;False;0;None;970f23754d65aa543b6962ff394c375f;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;136;194.938,1424.489;Float;False;Property;_CustomColor01;Custom Color 01;9;0;Create;True;0;0;False;0;1,0,0,0;0.4344828,0,0.5294118,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;299;-541.0941,3967.423;Float;False;647.3109;457.8635;Full RGB+Black Mask;3;158;134;148;;1,0,0,1;0;0
Node;AmplifyShaderEditor.BlendOpsNode;180;382.6046,1431.685;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.BreakToComponentsNode;134;-319.9076,4004.704;Float;False;COLOR;1;0;COLOR;0,0,0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;15;733.7712,3123.515;Float;False;Constant;_Float2;Float 2;4;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;140;196.9318,1583.468;Float;False;Property;_CustomColor02;Custom Color 02;10;0;Create;True;0;0;False;0;0,1,0,0;0.6323529,0.6221237,0.5691177,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;144;197.8842,1749.984;Float;False;Property;_CustomColor03;Custom Color 03;11;0;Create;True;0;0;False;0;0,0,1,0;0.5728702,0,0.5808823,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;179;404.5908,1585.903;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.CommentaryNode;158;-313.8467,4156.012;Float;False;396.9149;241.7827;Lessthan;3;160;159;161;;1,1,1,1;0;0
Node;AmplifyShaderEditor.LerpOp;165;677.4788,1420.286;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;181;388.2579,1749.469;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;167;201.8946,1908.251;Float;False;Property;_CustomColor04;Custom Color 04;12;0;Create;True;0;0;False;0;0,0,0,0;1,0.9310346,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;161;-303.877,4194.37;Float;False;Constant;_Float17;Float 17;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;159;-301.5383,4271.634;Float;False;Constant;_Float16;Float 16;6;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;183;815.4265,1522.351;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RGBToHSVNode;148;-522.0479,4157.787;Float;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.TFHCIf;160;-142.8778,4197.222;Float;False;6;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;301.7722,3151.515;Float;False;Constant;_Float1;Float 1;4;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;192;-1684.296,814.3031;Float;True;Property;_DyeMaskoptional;Dye Mask(optional);5;0;Create;True;0;0;False;0;None;0b4dc488e74c60b4db4f029cedeb13a3;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;184;950.2672,1622.848;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;182;390.0735,1909.752;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;226;205.6649,2070.072;Float;False;Constant;_DyemaskColorgray;Dyemask Color gray;12;0;Create;True;0;0;False;0;0.5019608,0.5019608,0.5019608,0;0.4852941,0.4852941,0.4852941,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;7;191.0039,2993.125;Half;False;Property;_TransparencyAmount;Transparency Amount;8;0;Create;True;0;0;True;0;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;283;890.1667,1983.724;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;239;1086.147,1727.043;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;204;207.8096,2236.029;Float;False;Property;_DyemaskColor01diffusetexture;Dyemask Color 01 (diffuse texture);13;0;Create;True;0;0;False;0;0,0.8235294,1,0;0.3382353,0.1492215,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;18;165.3271,2577.258;Float;False;627.4597;336.4263;Emission;4;296;297;5;4;;0.9862068,1,0,1;0;0
Node;AmplifyShaderEditor.BlendOpsNode;261;421.0065,2070.855;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;9;467.7725,3169.515;Float;False;Constant;_Float0;Float 0;4;0;Create;True;0;0;False;0;-1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;241;1088.759,1880.186;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;1;-1817.578,998.0718;Float;True;Property;_MRCTexture;MRC Texture;2;0;Create;True;0;0;False;0;None;c23f7122354672145ab64845e4611ede;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;12;469.7726,3059.515;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ToggleSwitchNode;282;1062.172,1960.456;Float;False;Property;_InvertdyemaskDiffusesAlphaChannel;Invert dyemask (Diffuse's Alpha Channel);1;0;Create;True;0;0;False;0;0;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;260;1221.396,1833.514;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;234;208.5729,2404.352;Float;False;Property;_DyemaskColor03MRCAlphaMask;Dyemask Color 03 (MRC Alpha Mask);14;0;Create;True;0;0;False;0;1,0,0.977,0;0.3014706,0.09044117,0.09044117,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;4;170.0846,2613.876;Float;False;Property;_EmissionAmount;Emission Amount;6;0;Create;True;0;0;False;0;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;191;986.7003,2085.048;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BlendOpsNode;209;483.9548,2235.946;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;604.7712,3059.515;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;3;-1948.714,1182.224;Float;True;Property;_NormalMap;Normal Map;4;0;Create;True;0;0;False;0;None;11a54c83db89ec8479d9264eb530f5c2;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ToggleSwitchNode;281;1169.68,2058.577;Float;False;Property;_InvertdyemaskMRCsAlphaChannel;Invert dyemask (MRC's Alpha Channel);3;0;Create;True;0;0;False;0;1;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;16;734.7712,3199.515;Float;False;Constant;_Float3;Float 3;4;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;262;1359.374,1935.997;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;10;747.7713,3025.515;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;5;189.9609,2692.713;Float;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.NegateNode;303;-1664.301,1296.185;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;297;388.8958,2612.251;Float;False;Property;_EmissionColor;Emission Color;7;0;Create;True;0;0;False;0;1,1,1,0;0,0,0,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BlendOpsNode;233;491.105,2405.519;Float;False;Overlay;True;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;302;-1514.409,1228.265;Float;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.ClampOpNode;14;871.7718,3049.515;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;280;1496.259,2039.139;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.BlendOpsNode;296;578.2877,2612.744;Float;False;ColorBurn;True;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1420.712,2583.951;Float;False;True;2;Float;ASEMaterialInspector;0;0;Standard;D2 NPC & EnemyRace Shader 1.0.1;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Background;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;3;1;False;-1;10;False;-1;2;5;False;-1;10;False;-1;1;False;-1;1;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;15;-1;-1;-1;0;True;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
//T-RUVAh_IvReDrLnpTZAe.o[rl2ae>eoEHom>nnP/s_E%AAit0tG_eLhZe_L,_.OP1_
//V0WNL>I_S.tYha_EfcEOZs7e2ifgryFuG_>AeeoeU6_tT>Eeoa7aO%_R_O__urRCPTT
//TNIEPNDSMiDNieYWnoLNaaFoo_opehelAnaMvn:GtiacLr__uth_UaeRLueYp_Zu.OT
//IUCSRERBEoA_heEA_GRLalesyo/_fgot__gpsa>Nvcmt/aAie0nrLaU.Rt_EnvM_>_M
//3EASMIR_IrREhhTNetLNpf>intiy__giIihRdes_c/fiUcE,_aWgNpkELdhTxe_nLT9
WireConnection;25;0;19;2
WireConnection;25;1;26;0
WireConnection;25;2;26;0
WireConnection;25;3;26;0
WireConnection;25;4;61;0
WireConnection;25;5;26;0
WireConnection;22;0;19;1
WireConnection;22;1;23;0
WireConnection;22;2;23;0
WireConnection;22;3;23;0
WireConnection;22;4;61;0
WireConnection;22;5;23;0
WireConnection;81;0;25;0
WireConnection;78;0;22;0
WireConnection;78;1;90;0
WireConnection;78;2;91;0
WireConnection;84;0;19;1
WireConnection;84;1;82;0
WireConnection;84;2;61;0
WireConnection;80;0;78;0
WireConnection;80;1;81;0
WireConnection;87;0;19;2
WireConnection;87;1;86;0
WireConnection;87;4;61;0
WireConnection;32;0;22;0
WireConnection;32;1;80;0
WireConnection;33;0;35;0
WireConnection;33;1;34;0
WireConnection;33;2;80;0
WireConnection;89;0;84;0
WireConnection;89;1;90;0
WireConnection;89;2;91;0
WireConnection;92;0;87;0
WireConnection;92;1;90;0
WireConnection;92;2;91;0
WireConnection;88;0;89;0
WireConnection;88;1;92;0
WireConnection;100;0;19;2
WireConnection;100;1;101;0
WireConnection;100;4;61;0
WireConnection;36;0;33;0
WireConnection;36;1;37;0
WireConnection;36;2;32;0
WireConnection;98;0;19;1
WireConnection;98;1;97;0
WireConnection;98;4;61;0
WireConnection;31;0;25;0
WireConnection;31;1;78;0
WireConnection;93;0;88;0
WireConnection;93;1;90;0
WireConnection;93;2;91;0
WireConnection;110;0;19;2
WireConnection;110;1;109;0
WireConnection;110;4;61;0
WireConnection;38;0;36;0
WireConnection;38;1;39;0
WireConnection;38;2;31;0
WireConnection;102;0;98;0
WireConnection;102;1;100;0
WireConnection;107;0;19;1
WireConnection;107;1;106;0
WireConnection;107;2;61;0
WireConnection;111;0;107;0
WireConnection;111;1;110;0
WireConnection;103;0;102;0
WireConnection;103;1;90;0
WireConnection;103;2;91;0
WireConnection;94;0;38;0
WireConnection;94;1;39;0
WireConnection;94;2;93;0
WireConnection;119;0;19;2
WireConnection;119;1;117;0
WireConnection;119;4;61;0
WireConnection;118;0;19;1
WireConnection;118;1;116;0
WireConnection;118;2;61;0
WireConnection;127;0;19;2
WireConnection;127;1;126;0
WireConnection;127;4;61;0
WireConnection;104;0;94;0
WireConnection;104;1;37;0
WireConnection;104;2;103;0
WireConnection;120;0;118;0
WireConnection;120;1;119;0
WireConnection;128;0;19;1
WireConnection;128;1;125;0
WireConnection;128;4;61;0
WireConnection;112;0;111;0
WireConnection;112;1;90;0
WireConnection;112;2;91;0
WireConnection;113;0;104;0
WireConnection;113;1;34;0
WireConnection;113;2;112;0
WireConnection;121;0;120;0
WireConnection;121;1;90;0
WireConnection;121;2;91;0
WireConnection;129;0;127;0
WireConnection;129;1;128;0
WireConnection;122;0;113;0
WireConnection;122;1;37;0
WireConnection;122;2;121;0
WireConnection;131;0;129;0
WireConnection;131;1;90;0
WireConnection;131;2;91;0
WireConnection;130;0;122;0
WireConnection;130;1;37;0
WireConnection;130;2;131;0
WireConnection;259;0;130;0
WireConnection;180;0;136;0
WireConnection;180;1;2;0
WireConnection;134;0;259;0
WireConnection;179;0;140;0
WireConnection;179;1;2;0
WireConnection;165;0;15;0
WireConnection;165;1;180;0
WireConnection;165;2;134;0
WireConnection;181;0;144;0
WireConnection;181;1;2;0
WireConnection;183;0;165;0
WireConnection;183;1;179;0
WireConnection;183;2;134;1
WireConnection;148;0;130;0
WireConnection;160;0;161;0
WireConnection;160;1;148;2
WireConnection;160;3;159;0
WireConnection;184;0;183;0
WireConnection;184;1;181;0
WireConnection;184;2;134;2
WireConnection;182;0;167;0
WireConnection;182;1;2;0
WireConnection;283;0;2;4
WireConnection;239;0;184;0
WireConnection;239;1;182;0
WireConnection;239;2;160;0
WireConnection;261;0;226;0
WireConnection;261;1;2;0
WireConnection;241;0;192;1
WireConnection;12;0;7;0
WireConnection;12;1;13;0
WireConnection;282;0;283;0
WireConnection;282;1;2;4
WireConnection;260;0;261;0
WireConnection;260;1;239;0
WireConnection;260;2;241;0
WireConnection;191;0;1;4
WireConnection;209;0;204;0
WireConnection;209;1;2;0
WireConnection;11;0;12;0
WireConnection;11;1;9;0
WireConnection;281;0;1;4
WireConnection;281;1;191;0
WireConnection;262;0;209;0
WireConnection;262;1;260;0
WireConnection;262;2;282;0
WireConnection;10;0;2;4
WireConnection;10;1;11;0
WireConnection;5;0;2;4
WireConnection;5;1;4;0
WireConnection;303;0;3;2
WireConnection;233;0;234;0
WireConnection;233;1;2;0
WireConnection;302;0;3;1
WireConnection;302;1;303;0
WireConnection;302;2;3;3
WireConnection;14;0;10;0
WireConnection;14;1;15;0
WireConnection;14;2;16;0
WireConnection;280;0;233;0
WireConnection;280;1;262;0
WireConnection;280;2;281;0
WireConnection;296;0;297;0
WireConnection;296;1;5;0
WireConnection;0;0;280;0
WireConnection;0;1;302;0
WireConnection;0;2;296;0
WireConnection;0;3;1;1
WireConnection;0;4;1;2
WireConnection;0;5;1;3
WireConnection;0;9;14;0
ASEEND*/
//CHKSM=E4C5081659FDB58030CC0E5BBE4721E96D4F6FA8
//If the credit at the top is deleted or edited from "Thejudsub" to something else, then this shader has been stolen and reposted in someone else's name. 