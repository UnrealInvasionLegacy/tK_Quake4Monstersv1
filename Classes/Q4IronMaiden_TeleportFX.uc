class Q4IronMaiden_TeleportFX extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=172,G=255,R=60))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=100,G=100,R=2))
         ColorScaleRepeats=1.000000
         Opacity=0.500000
         FadeOutFactor=(X=0.700000)
         MaxParticles=40
         StartLocationRange=(Z=(Min=-25.000000,Max=25.000000))
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Min=50.000000,Max=25.000000)
         SpinsPerSecondRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=10.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=20.000000)
         StartSizeRange=(X=(Min=6.000000,Max=6.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'tk_Quake4Monstersv1.MonsterTextures.launch_flash3_grey'
         LifetimeRange=(Min=0.200000,Max=0.500000)
         StartVelocityRange=(Z=(Max=1.000000))
         StartVelocityRadialRange=(Min=10.000000,Max=10.000000)
         VelocityScale(0)=(RelativeVelocity=(X=10.000000,Y=1010.000000,Z=5.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(Z=750.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4IronMaiden_TeleportFX.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Opacity=0.650000
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=0.500000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.000000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=80.000000,Max=60.000000))
         DrawStyle=PTDS_Darken
         Texture=Texture'EpicParticles.Smoke.Maelstrom01aw'
         LifetimeRange=(Min=0.100000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4IronMaiden_TeleportFX.SpriteEmitter1'

}
