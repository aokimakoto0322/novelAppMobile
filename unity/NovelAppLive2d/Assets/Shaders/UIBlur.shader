Shader "UI/CustomUIBlur"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (0.8, 0.8, 0.8, 1)
        _BlurSize ("Blur Size", Range(0, 20)) = 5.0

        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _ColorMask ("Color Mask", Float) = 15
    }

    SubShader
    {
        Tags
        {
            "Queue"="Transparent"
            "IgnoreProjector"="True"
            "RenderType"="Transparent"
            "PreviewType"="Plane"
            "CanUseSpriteAtlas"="True"
        }

        Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }

        Cull Off
        Lighting Off
        ZWrite Off
        ZTest [unity_GUIZTestMode]
        Blend SrcAlpha OneMinusSrcAlpha
        ColorMask [_ColorMask]

        Pass
        {
            Name "UIBlur"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            #include "UnityUI.cginc"

            struct appdata_t
            {
                float4 vertex   : POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex   : SV_POSITION;
                float4 color    : COLOR;
                float2 texcoord : TEXCOORD0;
                float4 worldPosition : TEXCOORD1;
            };

            sampler2D _MainTex;
            fixed4 _Color;
            float4 _MainTex_TexelSize;
            float _BlurSize;

            v2f vert(appdata_t v)
            {
                v2f OUT;
                OUT.worldPosition = v.vertex;
                OUT.vertex = UnityObjectToClipPos(OUT.worldPosition);
                OUT.texcoord = v.texcoord;
                OUT.color = v.color * _Color;
                return OUT;
            }

            fixed4 frag(v2f IN) : SV_Target
            {
                float2 uv = IN.texcoord;
                float2 step = _MainTex_TexelSize.xy * _BlurSize;

                fixed4 color = fixed4(0, 0, 0, 0);

                // Multi-sample Gaussian Blur for UI
                color += tex2D(_MainTex, uv + float2(-step.x * 2.0, -step.y * 2.0)) * 0.03;
                color += tex2D(_MainTex, uv + float2(-step.x,       -step.y * 2.0)) * 0.04;
                color += tex2D(_MainTex, uv + float2(0,             -step.y * 2.0)) * 0.05;
                color += tex2D(_MainTex, uv + float2( step.x,       -step.y * 2.0)) * 0.04;
                color += tex2D(_MainTex, uv + float2( step.x * 2.0, -step.y * 2.0)) * 0.03;

                color += tex2D(_MainTex, uv + float2(-step.x * 2.0, -step.y)) * 0.04;
                color += tex2D(_MainTex, uv + float2(-step.x,       -step.y)) * 0.08;
                color += tex2D(_MainTex, uv + float2(0,             -step.y)) * 0.10;
                color += tex2D(_MainTex, uv + float2( step.x,       -step.y)) * 0.08;
                color += tex2D(_MainTex, uv + float2( step.x * 2.0, -step.y)) * 0.04;

                color += tex2D(_MainTex, uv + float2(-step.x * 2.0, 0))       * 0.05;
                color += tex2D(_MainTex, uv + float2(-step.x,       0))       * 0.10;
                color += tex2D(_MainTex, uv + float2(0,             0))       * 0.15;
                color += tex2D(_MainTex, uv + float2( step.x,       0))       * 0.10;
                color += tex2D(_MainTex, uv + float2( step.x * 2.0, 0))       * 0.05;

                color += tex2D(_MainTex, uv + float2(-step.x * 2.0,  step.y)) * 0.04;
                color += tex2D(_MainTex, uv + float2(-step.x,        step.y)) * 0.08;
                color += tex2D(_MainTex, uv + float2(0,              step.y)) * 0.10;
                color += tex2D(_MainTex, uv + float2( step.x,        step.y)) * 0.08;
                color += tex2D(_MainTex, uv + float2( step.x * 2.0,  step.y)) * 0.04;

                color += tex2D(_MainTex, uv + float2(-step.x * 2.0,  step.y * 2.0)) * 0.03;
                color += tex2D(_MainTex, uv + float2(-step.x,        step.y * 2.0)) * 0.04;
                color += tex2D(_MainTex, uv + float2(0,              step.y * 2.0)) * 0.05;
                color += tex2D(_MainTex, uv + float2( step.x,        step.y * 2.0)) * 0.04;
                color += tex2D(_MainTex, uv + float2( step.x * 2.0,  step.y * 2.0)) * 0.03;

                color *= IN.color;
                return color;
            }
            ENDCG
        }
    }
}

