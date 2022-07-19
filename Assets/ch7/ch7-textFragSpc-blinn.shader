Shader "Custom/ch7/ch7-textFragSpc-blinn"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Texture2D", 2D) = "white" {}
        _Specular("Specular",Color) =(1.0,1.0,1.0,1.0)
        _Gloss("Gloss",Range(5,256)) =20
    }
    SubShader{
        Pass{
            Tags{ "LightMode"="ForwardBase"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _Specular;
            float _Gloss;
            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                float4 tex:TEXCOORD0;
            };
            struct v2f{
                float4 pos :SV_POSITION;
                fixed3 normWorld:TEXCOORD0;
                fixed3 posWorld:TEXCOORD1;
                fixed2 uv:TEXCOORD2;
            };

            v2f vert(a2v v){
                v2f o;
                o.pos= UnityObjectToClipPos(v.vertex);
                // o.normWorld=mul(v.normal,(float3x3)unity_WorldToObject);
                o.normWorld=UnityObjectToWorldNormal(v.normal);
                o.posWorld=mul(unity_ObjectToWorld,v.vertex).xyz;
                o.uv=v.tex.xy*_MainTex_ST.xy+_MainTex_ST.zw;
                return o;
            }

            fixed4 frag(v2f o):SV_TARGET{ 
                fixed3 normWorld =normalize(o.normWorld);
                // fixed3 lightPos=normalize(_WorldSpaceLightPos0.xyz);
                fixed3 texColor=tex2D(_MainTex,o.uv).rgb*_Color.rgb;

                fixed3 lightPos=normalize(UnityWorldSpaceLightDir(o.posWorld));
                fixed3 diffuse=_LightColor0.rgb*texColor*saturate(dot(normWorld,lightPos));
                
                fixed3 eyePos=normalize(UnityWorldSpaceViewDir(o.posWorld));
                fixed3 halfDir =normalize(lightPos+eyePos);
                fixed3 specular=_LightColor0.rgb*_Specular.rgb* pow(saturate(dot(normWorld,halfDir)),_Gloss);

                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz*texColor;

                // fixed3 color=ambient+diffuse+specular;
                fixed3 color=texColor;
                return fixed4(color,1);
            }



            ENDCG
        }
    }
    FallBack "Diffuse"
}
