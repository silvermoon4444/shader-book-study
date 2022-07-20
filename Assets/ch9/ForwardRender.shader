// Upgrade NOTE: replaced '_LightMatrix0' with 'unity_WorldToLight'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Shader "Unity Shaders Book/ch9/ForwardRenderMat"
// {
//     Properties{
//         _Diffuse("Diffuse",COLOR) =(1.0,1.0,1.0,1.0)
//         _Specular("Specular",COLOR) =(1.0,1.0,1.0,1.0)
//         _Gloss("Gloss",Range(5,256)) =20
//     }

//     SubShader{
//         Pass{
//             Tags{ "LightMode"="ForwardBase"}
//             CGPROGRAM
//             #pragma multi_compile_fwbase

//             #pragma vertex vert
//             #pragma fragment frag

//             #include "Lighting.cginc"

//             fixed4 _Diffuse;
//             fixed4 _Specular;
//             float _Gloss;
//             struct a2v{
//                 float4 vertex:POSITION;
//                 float3 normal:NORMAL;
//             };
//             struct v2f{
//                 float4 pos :SV_POSITION;
//                 fixed4 lightColor:TEXCOORD0;
//             };

//             v2f vert(a2v v){
//                 v2f o;
//                 o.pos= UnityObjectToClipPos(v.vertex);
//                 fixed3 lightWorld=normalize(_WorldSpaceLightPos0.xyz);
//                 fixed3 normalWorld=mul(v.normal,(float3x3)unity_WorldToObject);
//                 float3 diffuse=_LightColor0.rgb*_Diffuse.rgb*max(0,dot(lightWorld,normalWorld))             
//                 fixed3 specular=_LightColor0.rgb*_Specular.rgb* pow(saturate(dot(normalWorld,halfDir)),_Gloss);
//                 fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;//天空盒颜色

//                 fixed atten=1.0;
                
//                 return fixed4(ambient + (diffuse+specular)*atten,1.0);
//             }

//             fixed4 frag(v2f v):SV_TARGET{

//                 fixed3 color=v.lightColor;
//                 return color;
//             }

//             ENDCG
//         }

//         Pass{
//             Tags{ "LightMode"="ForwardAdd"}
//             CGPROGRAM
//             #pragma multi_compile_fwadd

//             #pragma vertex vert
//             #pragma fragment frag

//             #include "Lighting.cginc"
//             fixed4 _Diffuse;
//             fixed4 _Specular;
//             float _Gloss;
//             struct a2v{
//                 float4 vertex:POSITION;
//                 float3 normal:NORMAL;
//             };
//             struct v2f{
//                 float4 pos :SV_POSITION;
//                 fixed4 lightColor:TEXCOORD0;
//             };

//             v2f vert(a2v v){
//                 v2f o;
//                 o.pos= UnityObjectToClipPos(v.vertex);
//                 fixed3 lightWorld=normalize(_WorldSpaceLightPos0.xyz);
//                 fixed3 normalWorld=mul(v.normal,(float3x3)unity_WorldToObject);
//                 float3 diffuse=_LightColor0.rgb*_Diffuse.rgb*max(0,dot(lightWorld,normalWorld))             
//                 fixed3 specular=_LightColor0.rgb*_Specular.rgb* pow(saturate(dot(normalWorld,halfDir)),_Gloss);
//                 fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;//天空盒颜色

//                 fixed atten=1.0;
//                 o.lightColor=fixed4(ambient + (diffuse+specular)*atten,1.0);
//                 return o;
//             }

//             fixed4 frag(v2f v):SV_TARGET{

//                 #ifdef USING_DIRECTIONAL_LIGHT
//                     fixed atten = 1.0;
//                 #else
//                     #if defined (POINT)
//                         // 把点坐标转换到点光源的坐标空间中，_LightMatrix0由引擎代码计算后传递到shader中，这里包含了对点光源范围的计算，具体可参考Unity引擎源码。经过_LightMatrix0变换后，在点光源中心处lightCoord为(0, 0, 0)，在点光源的范围边缘处lightCoord模为1
//                         float3 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1)).xyz;
//                         // 使用点到光源中心距离的平方dot(lightCoord, lightCoord)构成二维采样坐标，对衰减纹理_LightTexture0采样。_LightTexture0纹理具体长什么样可以看后面的内容
//                         // UNITY_ATTEN_CHANNEL是衰减值所在的纹理通道，可以在内置的HLSLSupport.cginc文件中查看。一般PC和主机平台的话UNITY_ATTEN_CHANNEL是r通道，移动平台的话是a通道
//                         fixed atten = tex2D(_LightTexture0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
//                     #elif defined (SPOT)
//                         // 把点坐标转换到聚光灯的坐标空间中，_LightMatrix0由引擎代码计算后传递到shader中，这里面包含了对聚光灯的范围、角度的计算，具体可参考Unity引擎源码。经过_LightMatrix0变换后，在聚光灯光源中心处或聚光灯范围外的lightCoord为(0, 0, 0)，在点光源的范围边缘处lightCoord模为1
//                         float4 lightCoord = mul(unity_WorldToLight, float4(i.worldPos, 1));
//                         // 与点光源不同，由于聚光灯有更多的角度等要求，因此为了得到衰减值，除了需要对衰减纹理采样外，还需要对聚光灯的范围、张角和方向进行判断
//                         // 此时衰减纹理存储到了_LightTextureB0中，这张纹理和点光源中的_LightTexture0是等价的
//                         // 聚光灯的_LightTexture0存储的不再是基于距离的衰减纹理，而是一张基于张角范围的衰减纹理
//                         fixed atten = (lightCoord.z > 0) * tex2D(_LightTexture0, lightCoord.xy / lightCoord.w + 0.5).w * tex2D(_LightTextureB0, dot(lightCoord, lightCoord).rr).UNITY_ATTEN_CHANNEL;
//                     #else
//                         fixed atten = 1.0;
//                     #endif
//                 #endif

//                 fixed3 color=v.lightColor;
//                 return color;
//             }
            
//             ENDCG
//         }
//     }

//     Fallback "Diffuse"
// }


Shader "Unity Shaders Book/ch9/ForwardRenderMat"
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
            #pragma multi_compile_fwbase

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
                fixed4 lightColor:TEXCOORD0;
            };

            v2f vert(a2v v){
                v2f o;
                o.pos= UnityObjectToClipPos(v.vertex);
                fixed3 lightWorld=normalize(_WorldSpaceLightPos0.xyz);
                fixed3 normalWorld=mul(v.normal,(float3x3)unity_WorldToObject);
                float3 diffuse=_LightColor0.rgb*_Diffuse.rgb*max(0,dot(lightWorld,normalWorld));
                           
                // fixed3 specular=_LightColor0.rgb*_Specular.rgb* pow(saturate(dot(normalWorld,halfDir)),_Gloss); 
                fixed3 ambient=UNITY_LIGHTMODEL_AMBIENT.xyz;//天空盒颜色

                fixed atten=1.0;
                o.lightColor=fixed4(ambient + (diffuse)*atten,1.0);
                
                return o;
            }

            fixed4 frag(v2f v):SV_TARGET{

                return v.lightColor;
            }

            ENDCG
        }
    }

    Fallback "Diffuse"
}

