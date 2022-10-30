class Q4Voss_SpawnSphere extends Grenade placeable;

var() string MonsterToSpawn[3];
var() Quake4Monster MonsterOwner; //monster that spawned this
var() int Health;

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();

    if ( Role == ROLE_Authority )
    {
        Velocity = Speed * Vector(Rotation);
        RandSpin(25000);
        bCanHitOwner = false;
        if (Instigator.HeadVolume.bWaterVolume)
        {
            bHitWater = true;
            Velocity = 0.6*Velocity;
        }
    }
}

simulated function Landed( vector HitNormal )
{
    HitWall( HitNormal, None );
}

simulated function ProcessTouch( actor Other, vector HitLocation )
{}

simulated function Timer()
{
    SpawnMonster();
}

simulated function SpawnMonster()
{
	local class<Monster> MClass;
	local Monster M;

	SetCollision(false,false,false);

	if(Role == Role_Authority)
	{
		MClass = class<Monster>(DynamicLoadObject(MonsterToSpawn[Rand(3)], class'Class',true));
		if(MClass != None)
		{
			M = Spawn(MClass,,,Location+vect(0,0,10),Rot(0,0,0));
			if(M != None)
			{
				if(Invasion(Level.Game) != None)
				{
					Invasion(Level.Game).NumMonsters++;
				}

				PlaySound(Sound'tk_Quake4Monstersv1.IronMaiden.Button',SLOT_Interact);
				Spawn(class'Q4MonsterTeleportFX',,,M.Location,Rot(0,0,0));
				if(MonsterOwner != None)
				{
					MonsterOwner.NumSpawn++;
					if(Quake4Monster(M) != None)
					{
						Quake4Monster(M).MonsterOwner = MonsterOwner;
					}
				}
			}
		}
	}

	Explode(Location, vect(0,0,0));
}

simulated function Explode(vector HitLocation, vector HitNormal)
{
    if ( EffectIsRelevant(Location,false) )
    {
        Spawn(class'Q4Voss_SpawnSphere_Explode',,, Location);
    }

    Destroy();
}

function Destroyed()
{
	PlaySound(Sound'tk_Quake4Monstersv1.grunt.adren2',SLOT_Interact);
	Super(Projectile).Destroyed();
}

event TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	Health -= Damage;

	if(Health <= 0)
	{
		Explode(Location, vect(0,0,0));
	}
}

defaultproperties
{
     MonsterToSpawn(0)="tk_Quake4Monstersv1.Q4Grunt"
     MonsterToSpawn(1)="tk_Quake4Monstersv1.Q4Marine"
     MonsterToSpawn(2)="tk_Quake4Monstersv1.Q4Marine"
     Health=25
     Speed=500.000000
     Damage=0.000000
     ImpactSound=None
     ExplosionDecal=None
     StaticMesh=StaticMesh'tk_Quake4Monstersv1.Smeshes.Q4_SpawnSphere_model'
     DrawScale=1.000000
     Skins(0)=Shader'tk_Quake4Monstersv1.MonsterTextures.SpawnSphere_S'
     CollisionRadius=10.000000
     CollisionHeight=10.000000
     bProjTarget=True
     RotationRate=(Roll=80000)
     DesiredRotation=(Roll=30000)
}
