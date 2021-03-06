module RecursiveTypes where

data List a = Nil | Cons a (List a)

fromList :: List a -> [a]
fromList (Cons x xs) = x : fromList xs
fromList _           = []

toList :: [a] -> List a
toList (x:xs) = Cons x (toList xs)
toList _      = Nil

data Nat = Zero | Suc Nat deriving (Show)

fromNat :: Nat -> Integer
fromNat Zero    = 0
fromNat (Suc n) = fromNat n + 1

toNat :: Integer -> Nat
toNat 0 = Zero
toNat i = Suc . toNat $ i - 1

add :: Nat -> Nat -> Nat
add a b = toNat $ fromNat a + fromNat b

mul :: Nat -> Nat -> Nat
mul a b = toNat $ fromNat a * fromNat b

fac :: Nat -> Nat
fac n = toNat $ product [1..fromNat n]

data Tree a = Leaf a | Node (Tree a) (Tree a) deriving (Show)

height :: Tree a -> Int
height (Leaf _)          = 0
height (Node left right) = (height left `max` height right) + 1

size :: Tree a -> Int
size (Leaf _)          = 1
size (Node left right) = size left + size right + 1

avg :: Tree Int -> Int
avg t =
    let (c,s) = go t
    in s `div` c
  where
    go :: Tree Int -> (Int,Int)
    go (Leaf n) = (1, n)
    go (Node left right) = (lc + rc, ls + rs) where
        (lc, ls) = go left
        (rc, rs) = go right

infixl 6 :+:
infixl 7 :*:
data Expr = Val Int | Expr :+: Expr | Expr :*: Expr
    deriving (Show, Eq)

expand :: Expr -> Expr
expand ((e1 :+: e2) :*: e) = expand (e1 :*: e)  :+: expand (e2 :*: e)
expand (e :*: (e1 :+: e2)) = expand (e  :*: e1) :+: expand (e  :*: e2)

expand (e1 :+: e2) = expand e1 :+: expand e2

expand e@(Val _ :*: Val _) = e
expand origin@(e1 :*: e2) | origin == expanded = origin
                          | otherwise          = expand expanded
     where expanded = expand e1 :*: expand e2

expand e = e

{-
expand $ (Val 1 :+: Val 2 :+: Val 3) :*: (Val 4 :+: Val 5)
((Val 1 :*: Val 4 :+: Val 1 :*: Val 5) :+: (Val 2 :*: Val 4 :+: Val 2 :*: Val 5)) :+: (Val 3 :*: Val 4 :+: Val 3 :*: Val 5)
-}
