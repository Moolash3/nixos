{ config, pkgs, lib, ... }:

{
  # OpenGL / Vulkan userspace.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;   # 32-bit GL for Steam/Wine/etc.
  };

  # Use the NVIDIA driver for Xorg and Wayland.
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Kernel mode setting. REQUIRED for Wayland/Hyprland. Enabled by default on
    # drivers >= 535, but we set it explicitly.
    modesetting.enable = true;

    # Save full VRAM on suspend. Enable only if you get corruption/crashes after
    # waking from sleep (it costs disk + resume time).
    powerManagement.enable = false;

    # Fine-grained power management (turns the GPU off when idle).
    # Only works on Turing (RTX 20xx / GTX 16xx) or newer. Leave off unless needed.
    powerManagement.finegrained = false;

    # Open-source kernel modules (NOT nouveau).
    #   true  -> Turing (RTX 20xx / GTX 16xx) and newer  <-- most modern cards
    #   false -> Pascal (GTX 10xx) and older
    open = true;

    # The `nvidia-settings` control panel.
    nvidiaSettings = true;

    # Driver branch. `stable` is a good default; use `beta` or `production` if you
    # need a specific version (>= 555 is best for Wayland/explicit sync).
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Helpful for Wayland on NVIDIA. NVD_BACKEND=direct fixes some VA-API decode paths.
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    # If you hit cursor flicker/glitches on Hyprland, uncomment:
    # WLR_NO_HARDWARE_CURSORS = "1";
  };

  # --- Laptop with hybrid Intel/AMD + NVIDIA graphics? ----------------------
  # Uncomment and fill in your bus IDs (find them with `lspci`).
  # hardware.nvidia.prime = {
  #   offload.enable = true;
  #   offload.enableOffloadCmd = true;   # provides `nvidia-offload <cmd>`
  #   intelBusId = "PCI:0:2:0";
  #   nvidiaBusId = "PCI:1:0:0";
  # };
}
