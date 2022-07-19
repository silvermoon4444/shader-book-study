// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unity Shaders Book/ch6/ch6-diffuseFragmentLevel"
{
    Properties{
        _Diffuse("Diffuse",COLOR) =(1.0,1.0,1.0,1.0)
    }

    SubShader{
        Pass{
            Tags{ "LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Diffuse;
            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };
            struct v2f{
                float4 pos :SV_POSITION;
                fixed3 worldNormal:TEXCOORD0;
            };

            v2f vert(a2v v){
                v2f o;
                o.pos= UnityObjectToClipPos(v.vertex);
                o.worldNormal=mul(v.normal,(float3x3)unity_WorldToObject);
                
                return o;
            }

            fixed4 frag(v2f v):SV_TARGET{
                fixed3 norm=normalize(v.worldNormal);
                fixed3 lightColor=normalize(_WorldSpaceLightPos0.xyz);
                fixed halfLambert=dot(norm,lightColor)*0.5+0.5;
                fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*(halfLambert);
                // fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*saturate(dot(norm,lightColor));

                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 color=ambient+diffuse;
                return fixed4(color,1);
            }



            ENDCG
        }
    }

    Fallback "Diffuse"
}
