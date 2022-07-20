// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

Shader "Custom/test"
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
            #pragma multi_compile_fwbase

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
                float3 lightCoord = mul(unity_WorldToLight, float4(o.pos, 1)).xyz;

                fixed3 color=fixed3(1,1,1);
                float3 lightCoord = mul(unity_WorldToLight, float4(lightCoord, 1)).xyz;
                fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;

                return fixed4(1,0,0,1);
            }



            ENDCG
        }
    }
    FallBack "Diffuse"
}
