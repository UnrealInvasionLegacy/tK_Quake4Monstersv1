class Q4NetworkGuardian_ExhaustFX extends Quake4Emitter;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'AW-2004Particles.Weapons.TurretFlash'
         UseMeshBlendMode=False
         UseParticleColor=True
         UseColorScale=True
         SpinParticles=True
         UniformSize=True
         ColorScale(1)=(RelativeTime=0.330000,Color=(B=32,G=112,R=255))
         ColorScale(2)=(RelativeTime=0.660000,Color=(B=32,G=112,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         CoordinateSystem=PTCS_Relative
         MaxParticles=3
         StartSpinRange=(Z=(Max=1.000000))
         StartSizeRange=(X=(Min=-0.800000,Max=-1.000000))
         LifetimeRange=(Min=0.100000,Max=0.200000)
     End Object
     Emitters(0)=MeshEmitter'tk_Quake4Monstersv1.Q4NetworkGuardian_ExhaustFX.MeshEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseColorScale=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         UseRandomSubdivision=True
         ColorScale(1)=(RelativeTime=0.125000,Color=(B=28,G=192,R=250))
         ColorScale(2)=(RelativeTime=0.400000,Color=(B=26,G=112,R=255))
         ColorScale(3)=(RelativeTime=1.000000)
         ColorMultiplierRange=(X=(Max=0.900000),Y=(Min=0.800000,Max=0.500000),Z=(Min=1.200000,Max=1.200000))
         CoordinateSystem=PTCS_Relative
         MaxParticles=70
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=0.250000)
         StartSizeRange=(X=(Min=5.000000,Max=20.000000))
         ParticlesPerSecond=100.000000
         InitialParticlesPerSecond=100.000000
         Texture=Texture'AW-2004Particles.Weapons.SmokePanels1'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.200000,Max=0.200000)
         StartVelocityRange=(X=(Min=700.000000,Max=700.000000))
     End Object
     Emitters(1)=SpriteEmitter'tk_Quake4Monstersv1.Q4NetworkGuardian_ExhaustFX.SpriteEmitter0'

}
