---
name: stable-diffusion
description: Use when "Stable Diffusion", "text-to-image", "image generation", "Diffusers", or asking about "generate images", "SDXL", "inpainting", "ControlNet", "LoRA image", "img2img"
version: 1.0.0
---

<!-- Adapted from: AI-research-SKILLs/18-multimodal/stable-diffusion -->

# Stable Diffusion - Image Generation

Text-to-image generation with HuggingFace Diffusers library.

## When to Use

- Generate images from text prompts
- Image-to-image translation (style transfer)
- Inpainting (fill masked regions)
- ControlNet (guided generation)
- Custom styles with LoRA

## Quick Start

```bash
pip install diffusers transformers accelerate torch
```

```python
from diffusers import DiffusionPipeline
import torch

# Load pipeline
pipe = DiffusionPipeline.from_pretrained(
    "stable-diffusion-v1-5/stable-diffusion-v1-5",
    torch_dtype=torch.float16
)
pipe.to("cuda")

# Generate image
image = pipe(
    "A serene mountain landscape at sunset",
    num_inference_steps=50,
    guidance_scale=7.5
).images[0]

image.save("output.png")
```

## SDXL (Higher Quality)

```python
from diffusers import AutoPipelineForText2Image
import torch

pipe = AutoPipelineForText2Image.from_pretrained(
    "stabilityai/stable-diffusion-xl-base-1.0",
    torch_dtype=torch.float16,
    variant="fp16"
)
pipe.to("cuda")
pipe.enable_model_cpu_offload()  # Memory optimization

image = pipe(
    prompt="A futuristic city with flying cars",
    height=1024,
    width=1024,
    num_inference_steps=30
).images[0]
```

## Generation Parameters

```python
image = pipe(
    prompt="A cat wearing a top hat",
    negative_prompt="blurry, low quality, distorted",
    num_inference_steps=50,    # More = better quality
    guidance_scale=7.5,        # 7-12 typical
    height=512,
    width=512,
    generator=torch.Generator("cuda").manual_seed(42)  # Reproducible
).images[0]
```

## Image-to-Image

```python
from diffusers import AutoPipelineForImage2Image
from PIL import Image

pipe = AutoPipelineForImage2Image.from_pretrained(
    "stable-diffusion-v1-5/stable-diffusion-v1-5",
    torch_dtype=torch.float16
).to("cuda")

init_image = Image.open("input.jpg").resize((512, 512))

image = pipe(
    prompt="A watercolor painting of the scene",
    image=init_image,
    strength=0.75,  # 0-1, how much to transform
    num_inference_steps=50
).images[0]
```

## Inpainting

```python
from diffusers import AutoPipelineForInpainting
from PIL import Image

pipe = AutoPipelineForInpainting.from_pretrained(
    "runwayml/stable-diffusion-inpainting",
    torch_dtype=torch.float16
).to("cuda")

image = Image.open("photo.jpg")
mask = Image.open("mask.png")  # White = inpaint region

result = pipe(
    prompt="A red car parked on the street",
    image=image,
    mask_image=mask,
).images[0]
```

## ControlNet

```python
from diffusers import StableDiffusionControlNetPipeline, ControlNetModel
import torch

# Load ControlNet for edge conditioning
controlnet = ControlNetModel.from_pretrained(
    "lllyasviel/control_v11p_sd15_canny",
    torch_dtype=torch.float16
)

pipe = StableDiffusionControlNetPipeline.from_pretrained(
    "stable-diffusion-v1-5/stable-diffusion-v1-5",
    controlnet=controlnet,
    torch_dtype=torch.float16
).to("cuda")

# Use edge image as control
image = pipe(
    prompt="A house in Van Gogh style",
    image=canny_edge_image,
).images[0]
```

## LoRA Adapters

```python
pipe = DiffusionPipeline.from_pretrained(
    "stable-diffusion-v1-5/stable-diffusion-v1-5",
    torch_dtype=torch.float16
).to("cuda")

# Load LoRA
pipe.load_lora_weights("path/to/lora", weight_name="style.safetensors")

# Generate with style
image = pipe("A portrait in the trained style").images[0]

# Unload
pipe.unload_lora_weights()
```

## Memory Optimization

```python
# CPU offload
pipe.enable_model_cpu_offload()

# Attention slicing
pipe.enable_attention_slicing()

# VAE slicing for large images
pipe.enable_vae_slicing()
pipe.enable_vae_tiling()

# xFormers (requires installation)
pipe.enable_xformers_memory_efficient_attention()
```

## Fast Schedulers

```python
from diffusers import DPMSolverMultistepScheduler

# Swap for faster generation
pipe.scheduler = DPMSolverMultistepScheduler.from_config(pipe.scheduler.config)

# Generate with fewer steps
image = pipe(prompt, num_inference_steps=20).images[0]
```

## Best Practices

1. **Use SDXL** for higher quality (1024x1024)
2. **Use negative prompts** to avoid artifacts
3. **Enable CPU offload** for memory efficiency
4. **Use DPM scheduler** for faster generation
5. **Batch generate** for efficiency
6. **Set seed** for reproducibility

## Common Issues

**CUDA out of memory:**

```python
pipe.enable_model_cpu_offload()
pipe.enable_attention_slicing()
```

**Slow generation:**

```python
# Use faster scheduler, fewer steps
pipe.scheduler = DPMSolverMultistepScheduler.from_config(pipe.scheduler.config)
image = pipe(prompt, num_inference_steps=20).images[0]
```

## Resources

- Docs: <https://huggingface.co/docs/diffusers>
- GitHub: <https://github.com/huggingface/diffusers>
- Models: <https://huggingface.co/models?library=diffusers>
