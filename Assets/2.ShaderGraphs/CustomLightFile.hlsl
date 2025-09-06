	// 커스텀 라이트
void CustomLight_File_float(out float3 Direction, out float3 Color)
{
    #ifdef SHADERGRAPH_PREVIEW
		Direction = float3(1,1,1);
		Color = float3(1,1,1);
    #else
		Light light = GetMainLight();
		Direction = light.direction;
		Color = light.color;
    #endif
}
	// 커스텀 라이트 섀도우
void CustomLight_Shodow_float(float3 worldPos, out float ShadowAtten)
{
#ifdef SHADERGRAPH_PREVIEW
		ShadowAtten = 1.0f;
#else
	//shadow Cood 만들기
	#if defined(_MAIN_LIGHT_SHADOW_SCREEN) && !defined(_SURFACE_TYPE_TRANSPARENT)
		half4 clipPos = TransformWorldToHClip(worldPos);
		half4 shadowCoord = ComputeScreenPos(clipPos);
	#else
		half4 shadowCoord = TransformWorldToShadowCoord(worldPos);
	#endif
    Light light = GetMainLight();
	//메인 라이트가 없거나 받는 섀도우 오프 옵션이 되어 있을 경우 그림자를 없앤다.
	#if !defined(_MAIN_LIGHT_SHADOWS) || defined(_RECEIVE_SHADOWS_OFF)
		ShadowAtten = 1.0f;
	#endif
	//ShadowAtten 데이터 받아서 만들기
	#if SHADOWS_SCREEN
		ShadowAtten = SampleScreenSpaceShadowmap(shadowCoord);
	#else
		ShadowSamplingData shadowSamplingData = GetMainLightShadowSamplingData();
		half shadowStrenth = GetMainLightShadowStrength();
		ShadowAtten = SampleShadowmap(shadowCoord, TEXTURE2D_ARGS(_MainLightShadowmapTexture, sampler_MainLightShadowmapTexture), shadowSamplingData, shadowStrenth, false);
	#endif
	
    
	
#endif
}

	// 커스텀 추가 라이트 섀도우
void CustomLight_Additional_Shodow_float(float3 worldPos, out float ShadowAtten)
{
	#pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
#pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
#ifdef SHADERGRAPH_PREVIEW
		ShadowAtten = 1.0f;
#else
	//shadow Cood 만들기
#if defined(_ADDITIONAL_LIGHT_SHADOW_SCREEN) && !defined(_SURFACE_TYPE_TRANSPARENT)
		half4 clipPos = TransformWorldToHClip(worldPos);
		half4 shadowCoord = ComputeScreenPos(clipPos);
#else
    half4 shadowCoord = TransformWorldToShadowCoord(worldPos);
#endif
	
#if !defined(_ADDITIONAL_LIGHT_SHADOWS) || defined(_RECEIVE_SHADOWS_OFF)
    ShadowAtten = 1.0f;
#endif
	
	
	//ShadowAtten 데이터 받아서 만들기
#if SHADOWS_SCREEN
		ShadowAtten = SampleScreenSpaceShadowmap(shadowCoord);
#else
#ifdef _ADDITIONAL_LIGHT_SHADOWS
	half length = GetAdditionalLightsCount();
	#else
    half length = 2;
	#endif
	
    for (half i = 0; i < length; i++)
    {
        ShadowSamplingData shadowSamplingData = GetAdditionalLightShadowSamplingData(i);
        half shadowStrenth = GetAdditionalLightShadowStrenth(i);
		
        ShadowAtten = min(ShadowAtten, SampleShadowmap(shadowCoord, TEXTURE2D_ARGS(_AdditionalLightsShadowmapTexture, sampler_AdditionalLightsShadowmapTexture), shadowSamplingData, shadowStrenth, false));
    }
    ShadowAtten = length;
#endif
    
	
#endif
}