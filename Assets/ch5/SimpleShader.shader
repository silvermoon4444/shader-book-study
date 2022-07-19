// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 5/Simple Shader"
{
    Properties{
        _Color ("Color Tint",COLOR)=(1.0,1.0,1.0,1.0)
    }

    SubShader
    {
        Pass{
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag 

            fixed4 _Color;

            struct av2{
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };
            struct v2f{
                float4 pos : SV_POSITION;
                float3 color:COLOR0;
            };

            v2f vert( av2 v ){
                v2f o;
                o.pos= UnityObjectToClipPos(v.vertex);
                o.color=v.normal*0.5 + fixed3(0.5,0.5,0.5);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target{
                float3 c=i.color;
                c*=_Color.rgb;
                return fixed4(c,1.0);
            }

            ENDCG
        }
    }
    FallBack "Diffuse"
}
