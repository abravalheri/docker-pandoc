# docker-pandoc

Docker container for document writing backed by Pandoc, including a minimal
installation of Latex, `pandoc-citeproc` and `pandoc-crossref`.

## Usage

When called with `docker run`, this container will always execute `pandoc` from
the `/data` directory inside itself. Therefore please make sure to mount the
working directory to `/data`.

Additionally it may also be a good idea to run the container using your uid and
gid, so the produced files will have all the permissions automatically
adjusted.

Example:

```bash
docker run --rm -it -u $(id -u):$(id -g) -v $(pwd):/data \
  abravalheri:docker-pandoc example.md -o example.html
```

Remember also that `docker` is not good in redirecting binary output, and files
created that way may be corrupted. When necessary, run `bash` inside the
container (using `--entrypoint`) to interpret a command string, as showed
bellow:

```bash
docker run --rm -it -u $(id -u):$(id -g) -v $(pwd):/data \
  --entrypoint 'bash' docker-pandoc -c \
  'pandoc --print-default-data-file reference.docx > reference.docx'
```

### A note on changing docx table style

In order to change docx table style it is necessary to create a new reference
document (as indicated in the last example above) and editing it using Ms Word,
which is non-trivial.

For Ms Word 2016 (Windows version), this is accomplished by selecting the
example table, editing the configurations in `Table Tools > Design > Modify
Table Style` (in the `Table Style` dropdown) and then saving with the `New
documents based on this template` option selected.

The new template can be specified using CLI options, for example:

```bash
docker run --rm -it -u $(id -u):$(id -g) -v $(pwd):/data \
  abravalheri:docker-pandoc example.md -o example.docx \
  --reference-doc reference.docx
```
