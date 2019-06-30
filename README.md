# Minimal and composable Docker container set [PoC]

A collection (and build system) of neatly optimized containers to run any workload (some day, incomplete yet).

**Warning!** To get all of the benefits you have to use only images with the _same tag_. When you upgrade to new
tag then change tag for all `mcc` based image that you use. 

## Rationale

- The main idea is to share **exactly** the same image layer as base.
  * Reduces memory footprint due to **overlayfs** exposing inodes from the same image.
  * Reduces the IO overhead of running the containers (no need to read the same files for every container).
  * Reduces the amount of data to be transferred and stored.
  * Because of the above we can pull more handy packages into the base without thinking too much.
    It just does not have to be so size-optimized because it is fetched only once. 🎉
- Also the builds should be more deterministic - very specific versions shall be pulled.
- Each container has a *component* stage which shall contain only a single layer with only
  the files that need to be overlayed over base image to use that feature.
  * This allows to easily compose containers with multiple features by pulling every file
    from any chosen set of components.
  * Ideally we should make sure that the exact *component layer* is overlayed in the resulting
    image - this gives us the same benefit as using the same layer for base. I cannot guarantee 
    that yet with docker, but I will keep searching for a clean and universal solution.
    
**Obviously some of the benefits of this approach will be nullified if you don't use `overlayfs`, however,
being the default nowadays it would be a rare case.**

Read about this overlayfs inode magic in the original [kernel devel article](https://www.kernel.org/doc/Documentation/filesystems/overlayfs.txt).

## Docker hub org

The images are auto-built and pushed to [NimbleCo org at Docker Hub](https://hub.docker.com/u/nimbleco).
