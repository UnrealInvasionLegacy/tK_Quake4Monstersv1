class Q4Makron_DarkGrenade_Explode extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorMultiplierRange=(X=(Min=0.600000,Max=0.800000),Y=(Min=0.500000))
         FadeOutFactor=(X=0.700000)
         MaxParticles=30
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=20.000000)
         SpinsPerSecondRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=15.000000,Max=25.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'tk_Quake4Monstersv1.MonsterTextures.launch_flash3_grey'
         LifetimeRange=(Min=0.200000,Max=0.400000)
         StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=-1.000000,Max=1.000000))
         StartVelocityRadialRange=(Min=1.000000,Max=1.000000)
         RotateVelocityLossRange=True
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=150.000000,Y=150.000000,Z=150.000000))
         VelocityScale(1)=(RelativeTime=1.000000)
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4Makron_DarkGrenade_Explode.SpriteEmitter2'

}
