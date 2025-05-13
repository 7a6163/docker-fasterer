# docker-fasterer

[![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/7a6163/fasterer)](https://hub.docker.com/r/7a6163/fasterer)

Docker image for [fasterer](https://github.com/DamirSvrtan/fasterer) and [reviewdog](https://github.com/reviewdog/reviewdog).

## Usage

### Using Fasterer

Run fasterer on your Ruby project:

```bash
docker run --rm -v $(pwd):/app 7a6163/fasterer
```

With custom options:

```bash
docker run --rm -v $(pwd):/app 7a6163/fasterer fasterer -h
```

### Using Reviewdog

Run fasterer with reviewdog to get automated code review comments:

```bash
# For GitHub Pull Request review
docker run --rm -v $(pwd):/app -e REVIEWDOG_GITHUB_API_TOKEN="$GITHUB_TOKEN" 7a6163/fasterer sh -c "fasterer | reviewdog -f=fasterer -reporter=github-pr-review"

# For local review
docker run --rm -v $(pwd):/app 7a6163/fasterer sh -c "fasterer | reviewdog -f=fasterer -diff="git diff main""
```

### GitHub Actions Integration

Example workflow step:

```yaml
- name: Run fasterer with reviewdog
  uses: docker://7a6163/fasterer:latest
  with:
    entrypoint: sh
    args: -c "fasterer | reviewdog -f=fasterer -reporter=github-pr-review -fail-on-error=false"
  env:
    REVIEWDOG_GITHUB_API_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

### GitLab CI Integration

Example `.gitlab-ci.yml` configuration:

```yaml
fasterer:
  stage: lint
  image: 7a6163/fasterer:latest
  script:
    # For GitLab merge request comments
    - fasterer | reviewdog -f=fasterer -reporter=gitlab-mr-discussion
    # Or for just exit code
    - fasterer | reviewdog -f=fasterer -reporter=gitlab-mr-discussion -fail-on-error=true
  variables:
    REVIEWDOG_GITLAB_API_TOKEN: $GITLAB_TOKEN
  only:
    - merge_requests
```

Note: You'll need to set up a `GITLAB_TOKEN` CI/CD variable in your GitLab project settings with appropriate permissions.


## DONATE

If you want to support the project, you can buy the developer a coffee.

[!["Buy Me A Coffee"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/7a6163)
