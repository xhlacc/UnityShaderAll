/*----------------------------------------------------------------
// SHADER NAME：3_FirstSimpleDiffuse
// CREATER：Leon Xu
// DATE：2016.8.15
// DESCRIBE：镜面高光反射 顶点计算
//----------------------------------------------------------------*/
Shader "MyAllShader/005_SpecularVertexLevel"
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
			Tags{"LightMode" = "ForwardBase"}
			
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"
			
			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);

				//环境光
				fixed3 ambientColor = UNITY_LIGHTMODEL_AMBIENT.xyz;

				//法线 光 转换到世界坐标
				fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);

				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				//漫反射
				fixed3 diffuseLightColor = _Diffuse.rgb * _LightColor0.rgb * saturate(dot(worldNormal,worldLightDir));

				//高光

				//反射方向
				fixed3 reflectDir = normalize(reflect(-worldLightDir,worldNormal));

				//观察方向
				fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld,v.vertex).xyz);

				fixed3 specularColor = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir,viewDir)),_Gloss);

				o.color = ambientColor + diffuseLightColor + specularColor;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return fixed4(i.color,1.0);
			}

			ENDCG
		}
	}
	FallBack "Specular"
}