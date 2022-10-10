import Messenger.IExClient

# ugly, but enough for this example
for i <- 0..9, do: Node.connect(:"node#{i}@0.0.0.0")
