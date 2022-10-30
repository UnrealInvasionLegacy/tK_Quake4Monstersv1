class Q4HoverTank_HoverFX extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=128,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=85,G=250,R=150))
         ColorScale(2)=(RelativeTime=1.000000)
         FadeOutFactor=(X=0.700000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=25
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=15.000000,Max=20.000000)
         SpinsPerSecondRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=10.000000)
         StartSizeRange=(X=(Min=6.000000,Max=6.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AW-2004Particles.Fire.SmokeFragment'
         LifetimeRange=(Min=0.200000,Max=0.500000)
         StartVelocityRange=(X=(Min=-50.000000,Max=50.000000),Y=(Min=-50.000000,Max=50.000000),Z=(Min=-50.000000))
         StartVelocityRadialRange=(Min=-100.000000,Max=100.000000)
         VelocityScale(0)=(RelativeVelocity=(X=2.000000,Y=2.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=5.000000,Y=5.000000,Z=5.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4HoverTank_HoverFX.SpriteEmitter1'

}
