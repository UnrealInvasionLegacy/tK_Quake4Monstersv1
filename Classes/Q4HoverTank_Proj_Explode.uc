class Q4HoverTank_Proj_Explode extends Quake4Emitter;

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
         ColorScale(0)=(Color=(B=255,G=255,R=128))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=64,G=128))
         FadeOutFactor=(X=0.700000)
         MaxParticles=20
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=5.000000)
         SpinsPerSecondRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=6.000000,Max=4.000000))
         InitialParticlesPerSecond=2000.000000
         Texture=Texture'AW-2004Particles.Fire.SmokeFragment'
         LifetimeRange=(Min=0.200000,Max=0.500000)
         StartVelocityRange=(X=(Min=-1.000000,Max=1.000000),Y=(Min=-1.000000,Max=1.000000),Z=(Min=50.000000,Max=100.000000))
         StartVelocityRadialRange=(Min=-50.000000,Max=50.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
         VelocityScale(0)=(RelativeVelocity=(X=200.000000,Y=200.000000,Z=200.000000))
         VelocityScale(1)=(RelativeTime=1.000000,RelativeVelocity=(X=10.000000,Y=10.000000,Z=10.000000))
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.Q4HoverTank_Proj_Explode.SpriteEmitter0'

}
