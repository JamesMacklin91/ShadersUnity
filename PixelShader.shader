//Implemented by James Macklin
//purpose of this shader is to make an object appear pixelated

Shader "Custom/Pixelated"//sorts the shader into the custom shader folder
{
    //properties are exposed in the editor allowing for easy tweaks
	Properties 
	{
		_MainTex ("Main Texture", 2D) = "white" {}//Texture of the material
		_Color ("Color", Color) = (1, 1, 1, 1)//a Color Multiplier		
		_PixelCountX ("Pixel Count X", float) = 100//Number of pixels to display on the x axis
		_PixelCountY ("Pixel Count Y", float) = 100//Number of pixels to display on the y axis
	}

	SubShader 
	{
	    //tags must be inside the subshader section and not inside pass
		Tags {"Queue"="Transparent" "RenderType"="Transparent"}//Here The Rendering order is decided and a render type tag is used incase a replacement shader is used down the line
		LOD 100
		
		Lighting Off
		Blend SrcAlpha OneMinusSrcAlpha//this blend give us traditional transparency
		
        	Pass 
        	{            
			CGPROGRAM 
			#pragma vertex vert
			#pragma fragment frag
							
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;	
			float4 _Color;
			float _PixelCountX;
			float _PixelCountY;
					
			struct v2f 
			{
			    float4 pos : SV_POSITION;
			    float2 uv : TEXCOORD1;
			};
			
			v2f vert(appdata_base v)
			{
			    v2f o;			    
			    o.uv = v.texcoord.xy;
			    o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
			    
			    return o;
			}
			
			half4 frag(v2f i) : COLOR
			{   
				float pixelWidth = 1.0f / _PixelCountX;
				float pixelHeight = 1.0f / _PixelCountY;
				
				half2 uv = half2((int)(i.uv.x / pixelWidth) * pixelWidth, (int)(i.uv.y / pixelHeight) * pixelHeight);			
				half4 col = tex2D(_MainTex, uv);
			
			    return col * _Color;
			}
			ENDCG
	  	}
	}
	Fallback "Diffuse"
}