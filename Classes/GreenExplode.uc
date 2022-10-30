class GreenExplode extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.000000),Z=(Min=0.600000,Max=0.700000))
         Opacity=0.500000
         MaxParticles=100
         StartLocationRange=(X=(Min=-25.000000,Max=25.000000),Y=(Min=-25.000000,Max=20.000000),Z=(Min=-70.000000,Max=70.000000))
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Min=-25.000000,Max=25.000000)
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=20.000000,Max=5.000000))
         InitialParticlesPerSecond=350.000000
         Texture=Texture'AW-2004Particles.Fire.MuchSmoke2t'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.200000,Max=0.500000)
         StartVelocityRange=(Z=(Max=100.000000))
         StartVelocityRadialRange=(Min=-200.000000,Max=-100.000000)
         GetVelocityDirectionFrom=PTVD_AddRadial
     End Object
     Emitters(0)=SpriteEmitter'tk_Quake4Monstersv1.GreenExplode.SpriteEmitter0'

}
