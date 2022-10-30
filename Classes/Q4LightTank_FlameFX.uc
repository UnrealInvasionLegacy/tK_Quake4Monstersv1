class Q4LightTank_FlameFX extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=255))
         ColorScale(1)=(RelativeTime=0.500000)
         ColorScale(2)=(RelativeTime=1.000000)
         Opacity=0.100000
         CoordinateSystem=PTCS_Relative
         MaxParticles=75
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=5.000000,Max=10.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.800000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=20.000000,Max=40.000000))
         Texture=Texture'AW-2004Particles.Fire.SmokeFragment'
         LifetimeRange=(Min=1.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=250.000000,Max=200.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4LightTank_FlameFX.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseDirectionAs=PTDU_Up
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseVelocityScale=True
         ColorScale(0)=(Color=(B=23,G=151,R=244))
         ColorScale(1)=(RelativeTime=0.500000,Color=(B=192,G=192,R=192))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=102,G=152,R=255))
         Opacity=0.500000
         CoordinateSystem=PTCS_Relative
         MaxParticles=250
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=5.000000,Max=10.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.500000,RelativeSize=1.250000)
         SizeScale(2)=(RelativeTime=1.000000,RelativeSize=0.500000)
         StartSizeRange=(X=(Min=10.000000,Max=20.000000))
         Texture=Texture'AW-2004Explosions.Fire.Fireball1'
         LifetimeRange=(Min=1.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=250.000000,Max=200.000000),Z=(Min=1.000000,Max=1.000000))
         VelocityScale(0)=(RelativeVelocity=(X=1.000000,Z=1.000000))
         VelocityScale(1)=(RelativeTime=0.300000,RelativeVelocity=(X=1.000000,Z=1.000000))
         VelocityScale(2)=(RelativeTime=1.000000,RelativeVelocity=(X=1.000000,Z=50.000000))
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4LightTank_FlameFX.SpriteEmitter4'

}
