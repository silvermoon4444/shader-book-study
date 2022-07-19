// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/ch8/Alpha-blend"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("MainTex (RGB)", 2D) = "white" {}
        _AlphaScale ("AlphaScale", Range(0,1))=1

    }
    SubShader
    {
        Tags {"Queue"="Transparent" "IgnoreProjector"="true" "RenderType"="Transparent" }
        Pass{
            Tags{ "LightMode"="ForwardBase" }
            ZWrite off 
            Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"

            fixed4 _Color;
            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed _AlphaScale;

            struct a2v{
                float4 vertex:POSITION;
                float3 normal:NORMAL;
                float4 uv:TEXCOORD;
            };

            struct v2f{
                float4 pos:SV_POSITION;
                float3 norWorld:TEXCOORD0;
                float2 uv:TEXCOORD1;
                float3 worldPos:TEXCOORD2;
            };

            v2f vert(a2v a){
                v2f o;
                o.pos=UnityObjectToClipPos(a.vertex);
                o.norWorld=UnityObjectToWorldNormal(a.normal);
                o.worldPos=mul(unity_ObjectToWorld,a.vertex).xyz;
                o.uv=TRANSFORM_TEX(a.uv,_MainTex);

                return o;
            }
            
            fixed4 frag(v2f v):SV_TARGET{
                fixed3 worldNormal=normalize(v.norWorld);
                fixed3 worldLight=normalize(UnityWorldSpaceLightDir(v.worldPos));
                fixed4 texColor=tex2D(_MainTex,v.uv);
                
                fixed3 albedo=texColor.rgb * _Color.rgb;
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                fixed3 diffuse=_LightColor0.rgb * albedo * max(0,dot(worldNormal,worldLight));
                
                return fixed4(ambient+diffuse, texColor.a * _AlphaScale);
            }


            ENDCG
        }
    }
    FallBack "Transparent/Cutout/VertexLit"
}
