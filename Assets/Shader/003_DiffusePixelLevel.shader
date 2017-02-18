// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

/*----------------------------------------------------------------
// SHADER NAME：3_FirstSimpleDiffuse
// CREATER：Leon Xu
// DATE：2016.8.15
// DESCRIBE：漫反射效果 像素计算
//----------------------------------------------------------------*/
Shader "MyAllShader/003_DiffusePixelLevel"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
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

			struct a2v
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
			};

			v2f vert(a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				o.worldNormal = UnityObjectToWorldNormal(v.normal);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				fixed3 ambientColor = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 diffuseColor = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(i.worldNormal,worldLightDir));

				fixed3 finalColor = ambientColor + diffuseColor;

				return fixed4(finalColor,1.0);
			}
			ENDCG

		}
	}
}
