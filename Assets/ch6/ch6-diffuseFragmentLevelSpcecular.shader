// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Unity Shaders Book/ch6/ch6-diffuseFragmentLevelSpcecular"
{
    Properties{
        _Diffuse("Diffuse",COLOR) =(1.0,1.0,1.0,1.0)
        _Specular("Specular",COLOR) =(1.0,1.0,1.0,1.0)
        _Gloss("Gloss",Range(5,256)) =20
    }

    SubShader{
        Pass{
            Tags{ "LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Diffuse;
            fixed4 _Specular;
            float _Gloss;
            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
            };
            struct v2f{
                float4 pos :SV_POSITION;
                fixed3 normWorld:TEXCOORD0;
                fixed3 posWorld:TEXCOORD1;
            };

            v2f vert(a2v v){
                v2f o;
                o.pos= UnityObjectToClipPos(v.vertex);
                // o.normWorld=normalize(mul(v.normal,(float3x3)unity_WorldToObject));
                o.normWorld=mul(v.normal,(float3x3)unity_WorldToObject);
                o.posWorld=mul(unity_ObjectToWorld,v.vertex).xyz;

                return o;
            }

            fixed4 frag(v2f o):SV_TARGET{ 
                fixed3 normWorld =normalize(o.normWorld);
                fixed3 lightPos=normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse=_LightColor0.rgb*_Diffuse.rgb*saturate(dot(normWorld,lightPos));
                
                fixed3 reflectPos =normalize(reflect(-lightPos,normWorld));
                fixed3 eyePos=normalize(_WorldSpaceCameraPos.xyz- o.posWorld);
                fixed3 specular=_LightColor0.rgb*_Specular.rgb* pow(saturate(dot(eyePos,reflectPos)),_Gloss);

                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 color=ambient+diffuse+specular;
                return fixed4(color,1);
            }



            ENDCG
        }
    }

    Fallback "Diffuse"
}
