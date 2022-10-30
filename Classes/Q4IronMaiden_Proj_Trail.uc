class Q4IronMaiden_Proj_Trail extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         ColorScale(0)=(Color=(B=192,G=128,R=255))
         ColorScale(1)=(RelativeTime=0.200000,Color=(B=206,G=255,R=254))
         ColorScale(2)=(RelativeTime=1.000000,Color=(R=128))
         FadeInEndTime=0.050000
         MaxParticles=1
         StartLocationShape=PTLS_Sphere
         SpinCCWorCW=(X=0.000000,Y=0.000000,Z=0.000000)
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=8.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000))
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4IronMaiden_Proj_Trail.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseColorScale=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         Acceleration=(Z=50.000000)
         ColorScale(0)=(Color=(B=57,G=57,R=134))
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=111,G=111,R=217,A=190))
         ColorScale(2)=(RelativeTime=0.500000,Color=(B=200,G=200,R=200,A=255))
         ColorScale(3)=(RelativeTime=1.000000,Color=(B=80,G=80,R=80,A=255))
         Opacity=0.500000
         FadeInEndTime=0.500000
         MaxParticles=30
         SpinsPerSecondRange=(X=(Min=-0.200000,Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AW-2004Particles.Energy.BurnFlare'
         LifetimeRange=(Min=0.200000,Max=0.100000)
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4IronMaiden_Proj_Trail.SpriteEmitter2'

}
