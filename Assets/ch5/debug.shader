Shader "Unity Shaders Book/Chapter 5/debug"{
    SubShader{
        Pass{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag 

            #include "UnityCG.cginc"
            
            struct v2f{
                float4 pos : SV_POSITION;
                float4 color : COLOR0;
            };

            v2f vert(appdata_full v){
                v2f o;
                o.pos= UnityObjectToClipPos(v.vertex);
                // v.tangent.y 恒为0 切线
                // o.color= fixed4(fixed3(0,0,v.tangent.z)* 0.5 + fixed3(0.5,0.5,0.5),1.0);
                //副切线
                fixed3  binormal=cross(v.normal,v.tangent.xyz)*v.tangent.w;
                o.color=fixed4(binormal*0.5+ fixed3(0.5,0.5,0.5),1.0);
                return o;
            }

            float4 frag(v2f v) : SV_TARGET{
                // return fixed4(0,1,0,1);
                return v.color;
            }

            ENDCG

        }
    }
}