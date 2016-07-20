Shader "Custom/ToonShader" {
     Properties{
	     //_Color("Diffuse Material Color", Color) = (1,1,1,1)
		 //_UnlitColor("Unlit Color", Color) = (0.5,0.5,0.5,1)
		 _DiffuseThreshold("Lighting Threshold", Range(-1.1,1)) = 0.1
		 _SpecColor("Specular Material Color", Color) = (1,1,1,1)
		 _Shininess("Shininess",Range(0.5,1)) = 1
		 _OutlineThickness("Outline Thickness", Range(0,1)) = 0.1
		 _MainTex("Main Texture", 2D) = "White"{}
	 }

	 SubShader{
	     Pass{
		 Tags{"LightMode"="ForwardBase"}
		     CGPROGRAM
			 #pragma vertex vert
			 #pragma fragment frag

			 float4 _Color;
			 float4 _UnlitColor;
			 float _DiffuseThreshold;
			 float4 _SpecColor;
			 float _Shininess;
			 float _OutlineThickness;

			 float4 _LightColor0;
			 sampler2D _MainTex;
			 float4 _MainTex_ST;

			 struct appdata{
			     float4 vertex: POSITION;
				 float3 normal: NORMAL;
				 float4 texcoord: TEXCOORD0;
			 };

			 struct v2f{
			     float4 pos: SV_POSITION;
				 float3 normalDir: TEXCOORD1;
				 float4 lightDir: TEXCOORD2;
				 float3 viewDir: TEXCOORD3;
				 float2 uv: TEXCOORD0;
			 };

			 v2f vert(appdata IN){
			     v2f OUT;
				 OUT.normalDir = normalize(mul(float4(IN.normal,0.0), _World2Object).xyz);
				 float4 posWorld = mul(_Object2World, IN.vertex);
				 OUT.viewDir = normalize(_WorldSpaceCameraPos.xyz - posWorld.xyz);
				 float3 fragmentToLightSource = (_WorldSpaceCameraPos.xyz - posWorld.xyz);
				 OUT.lightDir = float4(normalize(lerp(_WorldSpaceLightPos0.xyz, fragmentToLightSource, _WorldSpaceLightPos0.w)),
				 lerp(1.0,1.0/length(fragmentToLightSource), _WorldSpaceLightPos0.w));
				 OUT.pos = mul(UNITY_MATRIX_MVP, IN.vertex);
				 OUT.uv = IN.texcoord;
				 return OUT;
			 }

			 float4 frag(v2f IN):COLOR{
			     float nDotL = saturate(dot(IN.normalDir, IN.lightDir.xyz));
				 float diffuseCutoff = saturate((max(_DiffuseThreshold, nDotL)- _DiffuseThreshold));
				 float specularCutoff = saturate(max(_Shininess, dot(reflect(-IN.lightDir.xyz, IN.normalDir), IN.viewDir))- _Shininess*1000);
				 float outlineStrength = saturate((dot(IN.normalDir, IN.viewDir)- _OutlineThickness));

				 fixed4 texColor = tex2D(_MainTex, IN.uv);
				 fixed4 unlitColor = texColor - (0.2,0.2,0.2,0.2);

				 float3 ambientLight = (1-diffuseCutoff) * unlitColor.xyz;
				 float3 diffuseReflection = (1-specularCutoff) * texColor.xyz * diffuseCutoff;
				 float3 specularReflection = _SpecColor.xyz * 0;

				 float3 combinedLight = (ambientLight + diffuseReflection) * (outlineStrength*10) + specularReflection;

				 


				 return float4(combinedLight,1.0);
			 }

			 ENDCG

		 }
	 }
	 FallBack "Diffuse"
}