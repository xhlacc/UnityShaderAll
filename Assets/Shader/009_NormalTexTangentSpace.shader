/*----------------------------------------------------------------
// SHADER NAME：9_NormalTexTangentSpace
// CREATER：Leon Xu
// DATE：2016.9.6
// DESCRIBE：法线纹理 切线空间计算
//----------------------------------------------------------------*/
Shader "MyAllShader/009_NormalTexTangentSpace"
{
	Properties
	{
		_Color ("Color Tint", Color) = (1,1,1,1)
		_MainTex ("Main Tex",2D) = "white" {}
		_BumpMap ("Normal Tex",2D) = "bump" {}
		_BumpScale ("Bump Scale",Float) = 1.0
		_Specular ("Speular",Color) = (1,1,1,1)
		_Gloss ("Gloss", Range(8.0,256)) = 20
	}

	SubShader
	{
		Pass
		{
			Tags {"LightMode" = "ForwardBase"}

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			fixed4 _Color;
			sampler2D _MainTex;		float4 _MainTex_ST;
			sampler2D _BumpMap;		float4 _BumpMap_ST;
			float _BumpScale;
			fixed4 _Specular;
			float _Gloss;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;			//两张图 xy表示漫反射纹理uv坐标，zw表示法线纹理uv坐标
				float3 lightDir : TEXCOORD1;
				float3 viewDir : TEXCOORD2;
			};

			v2f vert(a2v v)
			{
				v2f o = (v2f)0;

				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);

				//计算两张图的uv坐标
				o.uv.xy = TRANSFORM_TEX(v.texcoord,_MainTex);
				o.uv.zw = TRANSFORM_TEX(v.texcoord,_BumpMap);				

				//计算副法线，手动计算
				float3 binormal = cross( normalize(v.normal), normalize(v.tangent).xyz ) * v.tangent.w;
				float3x3 rotation = float3x3( v.tangent.xyz, binormal, v.normal );

				//或者使用内置 宏
				//TANGENT_SPACE_ROTATION;

				//灯光方向 模型空间 转 切线空间
				o.lightDir = mul(rotation,ObjSpaceLightDir(v.vertex)).xyz;

				//视角方向 模型空间 转 切线空间
				o.viewDir = mul(rotation,ObjSpaceViewDir(v.vertex)).xyz;

				return o;
			}

			fixed4 frag(v2f i) :SV_Target
			{
				fixed3 tangentLightDir = normalize(i.lightDir);
				fixed3 tangentViewDir = normalize(i.viewDir);

				//从图片中采样 
				fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);

				//定义切线控件下  法线值
				fixed3 tangentNormal;

				//法线贴图 没有设置格式为 "Normal map"  需要自己转换法线值
				//tangentNormal.xy = packedNormal.xy * 2 - 1;

				//法线贴图 设置格式为 "Normal map"  用Unity内置函数转换法线值
				tangentNormal = UnpackNormal(packedNormal);

				//缩放法线
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				//反射率 图片和颜色混合值
				fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color.rgb;
				
				//环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;

				//漫反射
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(tangentNormal, tangentLightDir));

				//高光反射
				fixed3 halfDir = normalize(tangentLightDir + tangentViewDir);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(tangentNormal, halfDir)), _Gloss);
				
				return fixed4(ambient + diffuse + specular, 1.0);
			}

			ENDCG
		}
	}

	FallBack "Specular"
}