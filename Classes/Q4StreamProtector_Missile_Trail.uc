class Q4StreamProtector_Missile_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         FadeOut=True
         FadeIn=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=255,G=255,R=255))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=206,G=255,R=254))
         ColorScale(2)=(RelativeTime=1.000000,Color=(B=64,G=64,R=128))
         Opacity=0.500000
         FadeInEndTime=0.050000
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=2.000000)
         StartSpinRange=(X=(Min=0.250000,Max=0.250000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.500000)
         StartSizeRange=(X=(Min=5.000000,Max=8.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=5.000000,Max=5.000000))
         Texture=Texture'AW-2004Particles.Weapons.HardSpot'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4StreamProtector_Missile_Trail.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=50.000000)
         ColorScale(0)=(Color=(B=64,G=64,R=128))
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=64,G=64,R=128,A=190))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=70,G=70,R=70,A=255))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=80,G=80,R=80,A=255))
         Opacity=0.400000
         MaxParticles=150
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=10.000000)
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(1)=(RelativeTime=0.200000,RelativeSize=1.750000)
         SizeScale(2)=(RelativeTime=1.000000)
         StartSizeRange=(X=(Min=5.000000,Max=8.000000),Y=(Min=20.000000,Max=20.000000))
         ParticlesPerSecond=200.000000
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AW-2004Particles.Fire.SmokeFragment'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4StreamProtector_Missile_Trail.SpriteEmitter1'

}
