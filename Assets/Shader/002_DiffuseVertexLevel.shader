// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

/*----------------------------------------------------------------
// SHADER NAME：2_FirstSimpleDiffuse
// CREATER：Leon Xu
// DATE：2016.8.15
// DESCRIBE：漫反射效果 顶点计算
//----------------------------------------------------------------*/
Shader "MyAllShader/002_DiffuseVertexLevel"
{
	//属性
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
	}

	SubShader
	{
		Pass
		{
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			//属性映射变量
			fixed4 _Diffuse;

			//输入 输出结构
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

			//定点计算
			v2f vert(a2v v)
			{
				v2f o;
				//转换模型空间坐标 到 投影坐标
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);

				//环境光颜色
				fixed3 ambientColor = UNITY_LIGHTMODEL_AMBIENT.xyz;

				//物体表面法线 转 世界空间坐标
				fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));

				//等同上面的计算 用的是unity内部函数
				//fixed3 worldNormal = UnityObjectToWorldNormal(v.normal);

				//世界空间 光的方向
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 diffuseColor = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal,worldLight));

				o.color = ambientColor + diffuseColor;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return fixed4(i.color,1.0);
			}

			ENDCG
		}

	}
}
