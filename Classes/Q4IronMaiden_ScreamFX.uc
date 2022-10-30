class Q4IronMaiden_ScreamFX extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseDirectionAs=PTDU_Forward
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(RelativeTime=0.200000,Color=(B=64,R=128))
         ColorScale(1)=(RelativeTime=1.000000)
         Opacity=0.700000
         CoordinateSystem=PTCS_Relative
         MaxParticles=50
         StartLocationShape=PTLS_Sphere
         SpinsPerSecondRange=(X=(Max=1.000000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=3.000000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         ScaleSizeByVelocityMultiplier=(X=0.100000)
         InitialParticlesPerSecond=75.000000
         Texture=Texture'tk_Quake4Monstersv1.MonsterTextures.launch_flash3_grey'
         LifetimeRange=(Min=0.500000,Max=1.000000)
         StartVelocityRange=(X=(Min=200.000000,Max=200.000000))
         WarmupTicksPerSecond=4.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4IronMaiden_ScreamFX.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseDirectionAs=PTDU_Forward
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(RelativeTime=0.200000,Color=(B=255,R=128))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=128,R=255))
         Opacity=0.200000
         CoordinateSystem=PTCS_Relative
         MaxParticles=250
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=5.000000,Max=10.000000)
         SpinsPerSecondRange=(X=(Max=5.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.250000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=10.000000,Max=15.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=200.000000
         Texture=Texture'AW-2004Particles.Energy.Circleband1'
         LifetimeRange=(Min=0.500000,Max=1.000000)
         StartVelocityRange=(X=(Min=250.000000,Max=200.000000),Z=(Min=1.000000,Max=1.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=1.000000,Z=1.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=1.000000,Z=50.000000))
         WarmupTicksPerSecond=4.000000
         RelativeWarmupTime=1.000000
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4IronMaiden_ScreamFX.SpriteEmitter1'

}
