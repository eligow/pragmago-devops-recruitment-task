# Task Manager API - DevOps Recruitment Solution

## Recruitment Task - Description

Your task is:

1. **Application Containerization**

2. **CI/CD Configuration**
   - Choose one of the CI systems (Jenkins or GitHub Actions)
   - Configure a pipeline that will:
     - Run static code analysis
     - Build and tag Docker images
  - Use RoadRunner instead of traditional PHP-FPM + web server setup

## Recruitment Task - Proposed solution

1. **Application Containerization**
    - Dockerfile is based on https://github.com/Baldinof/roadrunner (Usage with Docker section) with small modifications (e.g. install postgresql + composer update)

2. **CI/CD Configuration**
    - Used GitHub Actions, cause of easier integration
    
    - Workflows:
      - .github/workflows/build-pr.yaml - it builds/tags and pushes docker image to registry (tags: pr-'num', sha-'shorten commit sha') - triggered for Pull Requests
      - .github/workflows/build-release.yaml - it builds/tags and pushes docker image to registry, when push is on 'main' or 'beta' branch with semantic versioning
      - .github/workflows/composer-stan.yaml - Static Code Analysis for application (composer stan)
      - .github/workflows/semantic-release.yaml - it sets version number/pushes tag, adds changelogs and triggers build-release.yaml workflow
    
    - changelogs/* - generated notes of tagged versions

    - package.json - used for semantic versioning

    - RoadRunner configurations (based on https://github.com/Baldinof/roadrunner-bundle/blob/3.x/.rr.yaml):
      - .rr.yaml - production mode - used by default in container
      - .rr.yaml - development mode

    Fixes:
    - config/packages/doctrine.yaml - fix for env(DATABASE_URL) - https://github.com/eligow/pragmago-tech-recruitment-task/commit/2bc79a0b2e65f1ab4e933b5beaf9e2c1edc3d3c5#diff-111f6160993401b14acfc79685c56d1d62833a9f92887aeba2cb09e746e34fa7
    - config/bundles.php - BaldinofRoadRunnerBundle class - https://github.com/eligow/pragmago-tech-recruitment-task/commit/c117db09249bb68a376832c8f243538844d31897#diff-af64b33d4ab56a0603352c46e816701d32fd7f841fc8629b5c450e6b038348c2


    Next steps / improvements:
    - security scans for docker images / Dockerfile (trivy, dockle, hadolint, etc.)
    - paths for triggers workflows (only if needed, not always is necessary - e.g. doc changes)
    - update .dockerignore file - only add needed files
    - composer test/composer cs steps
    - simplify build workflow (build-release.yaml vs build-pr.yaml - at this moment, the only difference is tags names)