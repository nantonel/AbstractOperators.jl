immutable Scale{T1 <: RealOrComplex, T2 <: RealOrComplex, L <: LinearOperator} <: LinearOperator
  coeff::T1
  coeff_conj::T2
  A::L
end

# Constructors

Scale{T1 <: Number, T2<:LinearOperator}(coeff::T1, L::T2) =
Scale{codomainType(L), domainType(L), typeof(L)}(convert(codomainType(L), coeff), 
						 conj(convert(domainType(L), coeff)), 
						 L)

Scale{T <: Number}(coeff::T, L::Scale) = Scale(coeff.*L.coeff, L.A)

# Mappings

function A_mul_B!{T1, T2, C, D, A <: LinearOperator}(y::C, L::Scale{T1, T2, A}, x::D)
  A_mul_B!(y, L.A, x)
  y .*= L.coeff
end

function Ac_mul_B!{T1, T2, C, D, A <: LinearOperator}(y::D, L::Scale{T1, T2, A}, x::C)
  Ac_mul_B!(y, L.A, x)
  y .*= L.coeff_conj
end

# Properties

size(L::Scale) = size(L.A)

domainType(L::Scale) = domainType(L.A)
codomainType(L::Scale) = codomainType(L.A)

is_diagonal(L::Scale) = is_diagonal(L.A)
is_gram_diagonal(L::Scale) = is_gram_diagonal(L.A)
is_invertible(L::Scale) = L.coeff == 0 ? false : is_invertible(L.A)
is_full_row_rank(L::Scale) = is_full_row_rank(L.A)
is_full_column_rank(L::Scale) = is_full_column_rank(L.A)

fun_name(L::Scale) = "α$(fun_name(L.A))"
fun_type(L::Scale) = fun_type(L.A)