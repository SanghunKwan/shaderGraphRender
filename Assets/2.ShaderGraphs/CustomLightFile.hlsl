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