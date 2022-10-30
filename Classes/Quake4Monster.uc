class Quake4Monster extends Monster;

#EXEC OBJ LOAD FILE=Resources\tk_Quake4Monstersv1_rc.usx PACKAGE=tk_Quake4Monstersv1

var() Name MeleeAnims[4];
var() Name HitAnims[4];
var() Name DeathAnims[4];
var() Name RangedAttackAnims[4];
var() bool bLunging;
var() Actor Target;
var() Sound MeleeAttackSounds[4];
var() Sound FootStepSounds[4];
var() bool bBurning;
var() int BurnSpeed;
var() QuakeBurnTex BurnFX;
var() class<QuakeBurnTex> BurnClass;
var() Material FadingBurnMaterial;
var() Material InvisMat;
var() config float RangedAttackInterval;
var() config bool bCanBeTeleFrag;
var() config bool bUseDamageConfig;
var() config bool bUseHealthConfig;
var() config int MeleeDamage;
var() config int NewHealth;
var() bool bHasDeathAnim;
var() config bool bUseBurnEffect;
var() float LastHitTime;
var() float HitIntervalTime;
var() int NumSpawn;
var() Quake4Monster MonsterOwner; //for monsters that are summoned
var() float LastRangedAttack;
var() class<Projectile> ProjectileClass;
var() bool bUseBurnAwayEffect;
var() float DeathSpeed;

replication
{
    reliable if(Role==ROLE_Authority)
        Target, bUseBurnAwayEffect;
}

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if(Role == Role_Authority)
    {
        if(bUseHealthConfig)
        {
            Health = NewHealth;
        }
    }

    bUseBurnAwayEffect = bUseBurnEffect;
}

function RangedAttackBig()
{}

simulated function FreeFXObjects()
{
    if(BurnFX != None)
    {
        BurnFX.AlphaRef = 0;
        Level.ObjectPool.FreeObject(BurnFX);
        BurnFX = None;
    }
}

function MeleeAttack()
{
    if(Controller != None && Controller.Target != None)
    {
        if (MeleeDamageTarget(MeleeDamage, (30000 * Normal(Controller.Target.Location - Location))) )
        {
            PlaySound(MeleeAttackSounds[Rand(4)], SLOT_Interact);
        }
    }
}

function PlayMoverHitSound()
{
    PlaySound(HitSound[0], SLOT_Interact);
}

function bool SameSpeciesAs(Pawn P)
{
    //if Pawn is not equal to none and it has health left
    if(P != None && P.Health > 0)
    {
        //only checking for player/monster pawns
        if(P.Controller != None)
        {
            //if its a friendly monster i.e rpg or other mods which use it then no
            if(P.Controller.IsA('FriendlyMonsterController'))
            {
                return false;
            }
            else if(P.Controller.IsA('MonsterController')) //don't hurt other types of monsters
            {
                return true;
            }
            else
            {
                //damage all others ie players/bots
                return false;
            }
        }
    }

    //fallback to true
    return false;
}

simulated function HandleDeath()
{
    SetOverlayMaterial(None, 0.0f, true);
    SetCollision(false, false, false);
    Projectors.Remove(0, Projectors.Length);
    bAcceptsProjectors = false;
    if(PlayerShadow != None)
    {
        PlayerShadow.bShadowActive = false;
    }
    RemoveFlamingEffects();
}

simulated function PlayDirectionalDeath(Vector HitLoc)
{
    RemoveEffects();

    if(bUseBurnAwayEffect)
    {
        BurnFX = QuakeBurnTex(Level.ObjectPool.AllocateObject(BurnClass));
        HandleDeath();

        if(BurnFX == None)
        {
            FallbackDeath();
            return;
        }

        PlayAnim(DeathAnims[Rand(4)],DeathSpeed, 0.1);
    }
    else if(bHasDeathAnim && !bUseBurnAwayEffect)
    {
        PlayAnim(DeathAnims[Rand(4)],, 0.1);
    }
    else
    {
        HandleDeath();
        FallbackDeath();
    }
}

simulated function FallbackDeath()
{
    if(Level.NetMode != NM_DedicatedServer)
    {
        Spawn(class'Quake4DeathFX',,,location,rot(0,0,0));
        bHidden = true;
        Destroy();
    }
}

simulated function RemoveEffects()
{}

simulated function PlayDirectionalHit(Vector HitLoc)
{
    PlayAnim(HitAnims[Rand(4)],, 0.1);
}

function Sound GetSound(xPawnSoundGroup.ESoundType soundType)
{
    return None;
}

function PlayTakeHit(vector HitLocation, int Damage, class<DamageType> DamageType)
{
    if(Damage > 20 && Level.TimeSeconds - LastHitTime > HitIntervalTime)
    {
        LastHitTime = Level.TimeSeconds;
        Super.PlayTakeHit(HitLocation,Damage,DamageType);
    }
}

simulated function RunStep()
{
   PlaySound(FootStepSounds[Rand(4)], SLOT_Interact, 8);
}

function AddVelocity( vector NewVelocity)
{
    if((Velocity.Z > 350) && (NewVelocity.Z > 1000))
    {
        NewVelocity.Z *= 0.5;
    }

    Velocity += NewVelocity;
}

simulated function Destroyed()
{
    if(Role == Role_Authority)
    {
        if(MonsterOwner != None)
        {
            MonsterOwner.NumSpawn--;
        }
    }

    RemoveEffects();
    FreeFXObjects();
    Super.Destroyed();
}

simulated function StartDeRes()
{
    local int i;

    AmbientGlow=254;
    MaxLights=0;

    if( Level.NetMode == NM_DedicatedServer )
    {
        return;
    }

    Skins[0] = DeResMat0;
    Skins[1] = DeResMat1;
    if ( Skins.Length > 2 )
    {
        for ( i=2; i<Skins.Length; i++ )
            Skins[i] = DeResMat0;
    }

    AmbientSound = Sound'GeneralAmbience.Texture19';
    SoundRadius = 40.0;
    SetCollision(false, false, false);
    Projectors.Remove(0, Projectors.Length);
    bAcceptsProjectors = false;
    if(PlayerShadow != None)
    {
        PlayerShadow.bShadowActive = false;
    }
    RemoveFlamingEffects();
    SetOverlayMaterial(None, 0.0f, true);
    bDeRes = true;
}

State Dying
{
ignores AnimEnd, Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

    simulated function AnimEnd( int Channel )
    {
        ReduceCylinder();
    }

    event FellOutOfWorld(eKillZType KillType)
    {
        Super(UnrealPawn).FellOutOfWorld(KillType);
    }

    function Landed(vector HitNormal)
    {
        SetPhysics(PHYS_None);
        if ( !IsAnimating(0) )
            LandThump();
        Super.Landed(HitNormal);
    }

    function LandThump()
    {
        // animation notify - play sound if actually landed, and animation also shows it
        if ( Physics == PHYS_None)
        {
            bThumped = true;
            PlaySound(GetSound(EST_CorpseLanded));
        }
    }

    simulated function Timer()
    {
        if ( !PlayerCanSeeMe() )
        {
            Destroy();
        }
        else if ( LifeSpan <= DeResTime && bDeRes == false )
        {
            StartDeRes();
        }
        else
        {
            SetTimer(1.0, false);
        }
    }

    simulated function Tick(float deltatime)
    {
        local int i;

        if(bBurning && bUseBurnAwayEffect)
        {
            if(BurnFX != None)
            {
                if(BurnFX.AlphaRef != 255)
                {
                    if(BurnFX.AlphaRef == 244)
                    {
                        BurnSpeed = 1;
                    }

                    BurnFX.AlphaRef += BurnSpeed;
                }
                else
                {
                    for(i=0;i<Skins.Length;i++)
                    {
                        Skins[i] = InvisMat;
                        bHidden = true;
                    }

                    Disable('Tick');
                }
            }
        }
    }

    simulated function BeginState()
    {
        Super.BeginState();
        AmbientSound = None;
    }
}

event EncroachedBy( actor Other )
{
    if(bCanBeTeleFrag)
    {
        Super.EncroachedBy(Other);
    }
}

simulated function BurnAway()
{
    AmbientGlow = 254;
}

defaultproperties
{
     BurnSpeed=2
     BurnClass=Class'tk_Quake4Monstersv1.QuakeBurnTex'
     InvisMat=Shader'tk_Quake4Monstersv1.MonsterTextures.InvisMat'
     bCanBeTeleFrag=True
     bUseBurnEffect=True
     HitIntervalTime=4.000000
     bUseBurnAwayEffect=True
     DeathSpeed=0.250000
     DeResTime=2.000000
     DeResGravScale=10.000000
}
