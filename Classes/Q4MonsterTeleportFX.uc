class Q4MonsterTeleportFX extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Up
         UseColorScale=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ScaleSizeXByVelocity=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorScale(0)=(Color=(G=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=128))
         ColorMultiplierRange=(Z=(Min=1.200000,Max=1.200000))
         Opacity=0.500000
         FadeOutFactor=(X=0.700000)
         MaxParticles=40
         StartLocationRange=(Z=(Min=-50.000000,Max=50.000000))
         StartLocationShape=PTLS_All
         SphereRadiusRange=(Max=25.000000)
         SpinsPerSecondRange=(X=(Min=-5.000000,Max=10.000000))
         SizeScale(0)=(RelativeSize=15.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=3.000000)
         StartSizeRange=(X=(Min=6.000000,Max=6.000000))
         ScaleSizeByVelocityMultiplier=(X=0.001000)
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'tk_Quake4Monstersv1.MonsterTextures.launch_flash3_grey'
         LifetimeRange=(Min=0.200000,Max=0.500000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
         StartVelocityRadialRange=(Min=-50.000000,Max=50.000000)
         VelocityScale(0)=(RelativeVelocity=(X=4.000000,Y=4.000000,Z=-2.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=-5.000000,Y=-5.000000,Z=20.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4MonsterTeleportFX.SpriteEmitter0'

}
