class Q4Makron_ShockFX extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'tk_Quake4Monstersv1.Smeshes.BerserkerWave'
         UseParticleColor=True
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         ColorScale(0)=(Color=(B=255,G=225,R=240))
         ColorScale(1)=(RelativeTime=0.800000,Color=(B=128,R=255))
         ColorScale(2)=(RelativeTime=0.900000,Color=(B=255,G=255,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         ColorMultiplierRange=(Y=(Min=0.000000,Max=0.000000))
         SizeScale(0)=(RelativeSize=0.250000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=1.200000,Max=1.200000),Y=(Min=1.200000,Max=1.200000),Z=(Min=0.500000,Max=0.500000))
         InitialParticlesPerSecond=50.000000
         LifetimeRange=(Min=0.400000,Max=0.500000)
         WarmupTicksPerSecond=10.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=MeshEmitter'tk_Quake4Monstersv1.Q4Makron_ShockFX.MeshEmitter0'

     AmbientGlow=255
}
