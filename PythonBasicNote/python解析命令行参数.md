- sys模块实现

  ```python
  import sys
  if __name__ == '__main__':
     for value in sys.argv:
         print(value)
  ```

- argparse模块实现

  ```python
  from argparse import ArgumentParser
  if __name__ == "__main__":
     argparser = ArgumentParser(description='My Cool Program')
     argparser.add_argument("--foo", "-f", help="A user supplied foo")
     argparser.add_argument("--bar", "-b", help="A user supplied bar")
     
     results = argparser.parse_args()
     print(results.foo, results.bar)
  ```

- click框架（使用装饰器）

  ```python
  import click
  @click.command()
  @click.option("-f", "--foo", default="foo", help="User supplied foo.")
  @click.option("-b", "--bar", default="bar", help="User supplied bar.")
  def echo(foo, bar):
      """My Cool Program
     
      It does stuff. Here is the documentation for it.
      """
      print(foo, bar)
     
  if __name__ == "__main__":
      echo()
  ```

- typer框架（建立在click之上）

  ```python
  import typer
  cli = typer.Typer()
  @cli.command()
  def echo(foo: str = "foo", bar: str = "bar"):
      """My Cool Program
     
      It does stuff. Here is the documentation for it.
      """
      print(foo, bar)
     
  if __name__ == "__main__":
      cli()
  ```

  