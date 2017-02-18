/*----------------------------------------------------------------
// SHADER NAME：1_FirstSimple
// CREATER：Leon Xu
// DATE：2016.8.15
// DESCRIBE：简单例子
//----------------------------------------------------------------*/
Shader "MyAllShader/001_FirstSimple"
{
	SubShader
	{
		Pass
		{
			CGPROGRAM
			//定义 定点函数 像素函数 名字
			#pragma vertex vert	
			#pragma fragment frag

			//输入 定点位置  输出 裁剪空间中的位置
			float4 vert (float4 v : POSITION) : SV_POSITION
			{
				float4 outPos =  mul(UNITY_MATRIX_MVP, v);
				return outPos;
			}
			
			//将颜色输出到 帧缓冲中
			fixed4 frag () : SV_Target
			{
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				return fixed4(lightDir,1.0);
				//return fixed4(1.0,1.0,1.0,1.0);
			}
			ENDCG
		}
	}
}
