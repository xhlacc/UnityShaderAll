/*----------------------------------------------------------------
// SHADER NAME：6_SpecularPixelLevel
// CREATER：Leon Xu
// DATE：2016.8.17
// DESCRIBE：镜面高光反射 像素处理
//----------------------------------------------------------------*/
Shader "MyAllShader/006_SpecularPixelLevel"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)	
		_Specular("Specular",Color) = (1,1,1,1)
		_Gloss("Gloss",Range(8,256)) = 20
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

			fixed4 _Diffuse;
			fixed4 _Specular;
			float  _Gloss;
			
			struct a2v
			{
				float4 vertex : POSITION;
				float4 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldPos : TEXCOORD1;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				o.worldPos = mul(unity_ObjectToWorld,v.vertex).xyz;
				return o;
			}

			fixed4 frag(v2f i) :SV_Target
			{
				fixed3 ambientColor = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 diffuseColor = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldLightDir,i.worldNormal));

				fixed3 reflectDir = normalize(reflect(-worldLightDir,i.worldNormal));

				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

				fixed3 specularColor =  _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir,viewDir)),_Gloss);

				fixed3 finalColor = ambientColor + diffuseColor + specularColor;

				return fixed4(finalColor,1.0);
			}

			ENDCG
		}
	}
	FallBack "Specular"
}