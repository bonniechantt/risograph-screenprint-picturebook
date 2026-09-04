# Risograph Screen Print Picturebook

A reusable Codex Skill for transforming supplied photos into Japanese independent-picture-book Risograph or screen-print illustrations.

## What it does

- Treats clean single-object photos as centered editorial object plates.
- Extracts the intended subject from composite photos instead of applying a uniform filter over the whole scene.
- Re-centers and re-composes extracted subjects with balanced negative space.
- Outputs an exact 3:4 vertical portrait canvas by default, recomposing or cropping sources without stretching the subject.
- Uses restrained retro inks, fine halftone fields, light paper fibers, and subtle registration variation.
- Requires a pre-generation text confirmation: use exact user wording or explicit permission for subject-based automatic wording; otherwise add no new text.
- Locks the source orientation during extraction and re-composition, with no rotation, flip, or mirror unless explicitly requested.

## Install

Copy this folder into the Codex skills directory on the target machine, then invoke the Skill by name or let Codex select it for a matching image-transformation request.

The folder must keep this structure:

```text
risograph-screenprint-picturebook/
├── SKILL.md
├── agents/openai.yaml
└── scripts/apply_unified_title.swift
```

## Use

Provide one or more source images and ask Codex to use `risograph-screenprint-picturebook`. For composite images, specify whether the desired output is a centered single-subject plate or a relationship scene when that distinction matters.
