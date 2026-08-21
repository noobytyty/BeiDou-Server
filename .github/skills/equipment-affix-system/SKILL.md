---
name: equipment-affix-system
description: Implement, rebalance, document, and validate BeiDou equipment affixes across database, persistence, runtime effects, and player display.
---

# Equipment Affix System

Use this skill whenever adding, removing, rebalancing, naming, or documenting an equipment affix.

## Required four-layer workflow

Every affix change must be checked across all four layers:

1. **Database configuration**
   - Never edit an already released Flyway migration; add the next version.
   - Update `equipment_affix_definition`, `equipment_affix_range`,
     `equipment_affix_name`, `equipment_affix_pool`, and
     `equipment_affix_level_pool` as applicable.
   - `equipment_affix_name` is keyed by `affix_code + affix_tier`. Do not use one
     generic name for every affix at the same tier.
   - New pool changes must update both the normal pool and level pool.

2. **Instance and persistence chain**
   - Preserve affix code, tier, value, item quality, and affix type through
     `Equip`, `ItemFactory`, inventory persistence, trading, shops, copying, and deletion.
   - Mixed flat affixes are contributions, not values to write back into the
     equipment base stats. Otherwise a reload or reroll can double-count them.

3. **Runtime effects**
   - Add percentage and conditional effects to one shared server-side calculation
     entry point.
   - Apply mixed-affix reduction consistently in both calculation and display.
   - Keep explicit caps for percentage systems. Current caps are:
     Boss damage 70%, ignore defense 60%, drop/exp/meso 60%, Boss reduction 70%,
     and each elemental damage type 25%.

4. **Player display**
   - v83 clients do not dynamically render equipment-instance names from WZ data.
   - Use the shared formatter for pickup text and `@inspect`/`@affix`.
   - Display the tier-specific affix name, original roll, tier, and actual
     contribution values for mixed affixes.
   - Missing translations must fall back to an explicit human-readable label,
     never a database key.

## Naming rules

The current naming model is not “tier prefix + generic affix name”.
Each `affix_code` has a distinct T1–T12 name progression:

```text
equipment.prefix.fire_damage.t1 = 火花
equipment.prefix.fire_damage.t8 = 天火
equipment.prefix.fire_damage.t12 = 末日炎狱
```

Chinese names should follow ARPG naming conventions: short, evocative, and
effect-oriented. Do not force animal imagery onto every affix. Use combat,
defense, mobility, economy, arcane, and elemental themes; reserve mythic or
animal imagery for occasional exceptional names.

When adding names, update both:

- `message_zh_CN.properties`
- `message_en_US.properties`

and update `docs/EQUIPMENT_AFFIX_T1_T12.md` with the code, all T1–T12 values,
all T1–T12 names, and applicable equipment types.

## Pool and balance rules

- Quality controls affix count; equipment requirement level controls the tier
  mean/window. Do not make quality silently cap the tier.
- Core attributes and class-oriented offensive combinations should dominate
  their relevant slots.
- Low-value mixed utility/resource combinations must remain possible but rare.
  Examples currently reduced to weight 4 include `STR_MP`, `LUK_MP`, `INT_MP`,
  `DEX_HP`, `INT_HP`, `HP_ACC`, `MP_ACC`, `WATK_SPEED`, `MATK_MDEF`,
  `INT_MDEF`, `LUK_SPEED`, and `DEX_JUMP`.
- Historical cross-class combinations can remain loadable for old equipment while
  being disabled for new generation.
- When changing weights, update both `equipment_affix_pool` and
  `equipment_affix_level_pool` in a new migration.

## Elemental weapon rules

- `FIRE_DAMAGE`, `ICE_DAMAGE`, `LIGHTNING_DAMAGE`, and `HOLY_DAMAGE` may appear
  on ordinary wands/staves, but one item may have at most one elemental affix.
- Elemental wands/staves only generate their matching element, with increased
  weight. The classic mapping is:
  - Elemental 1/6: fire
  - Elemental 2/7: ice
  - Elemental 3/8: lightning
  - Elemental 4/5: holy
- A skill receives the affix only when its element matches; neutral skills do
  not receive elemental affix damage.
- Verify every non-standard damage path before claiming complete coverage.

## Migration validation checklist

Before declaring an affix change complete:

```bash
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export PATH="$JAVA_HOME/bin:$PATH"
mvn -pl gms-server -DskipTests compile
git diff --check
```

Also statically inspect SQL for:

- matching unique-index names before `DROP INDEX`;
- valid MySQL syntax such as `` `affix_code` IN (...) ``;
- synchronized normal and level pools;
- `enabled = 0` being respected by all loaders.

Prefer a real MySQL/Flyway upgrade test when available. In particular, do not
assume a migration is safe merely because Java compilation succeeds.

## Player interaction

The recommended flow is:

```text
Equipment pickup -> affix summary in chat
@inspect          -> equipment slots and affix count
@inspect 1        -> full names, tiers, rolls, and actual contributions
@affix 1          -> same formatter and same output
```
