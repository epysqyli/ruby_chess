# black and white unicodes used in opposite way due to final display qualities
# apply encode. Example: puts black_pieces[:king].encode. Maybe add encode function later

black_pieces = {
  king: "\u2654",
  queen: "\u2655",
  rook: "\u2656",
  bishop: "\u2657",
  knight: "\u2658",
  pawn: "\u2659"
}

white_pieces = {
  king: "\u265A",
  queen: "\u265B",
  rook: "\u265C",
  bishop: "\u265D",
  knight: "\u265E",
  pawn: "\u265F"
}

p black_pieces
