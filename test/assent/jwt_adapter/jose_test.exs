defmodule Assent.JWTAdapter.JOSETest do
  use ExUnit.Case
  doctest Assent.JWTAdapter.JOSE

  alias Assent.JWTAdapter.{JOSE, JWT}

  @jwt "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1MTYyMzkwMjIsIm5hbWUiOiJKb2huIERvZSIsInN1YiI6IjEyMzQ1Njc4OTAifQ.fdOPQ05ZfRhkST2-rIWgUpbqUsVhkkNVNcuG7Ki0s-8"
  @header %{"alg" => "HS256", "typ" => "JWT"}
  @payload %{"iat" => 1_516_239_022, "name" => "John Doe", "sub" => "1234567890"}
  @secret "your-256-bit-secret"

  test "sign/2" do
    assert {:ok, @jwt} = JOSE.sign(%JWT{header: @header, payload: @payload}, @secret, json_library: Jason)
  end

  test "verify/3" do
    {:ok, jwt} = JOSE.decode(@jwt, json_library: Jason)

    assert JOSE.verify(jwt, @secret, [])
  end

  test "decode/2" do
    assert {:ok, %JWT{header: @header, payload: @payload}} = JOSE.decode(@jwt, json_library: Jason)
  end

  describe "with private key" do
    @header Map.put(@header, "alg", "RS256")
    @jwt "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE1MTYyMzkwMjIsIm5hbWUiOiJKb2huIERvZSIsInN1YiI6IjEyMzQ1Njc4OTAifQ.Skbmm3dBBdPCt0T1dqgtIYW_xbsmlOMJxC6g4WEgWRbk21tw2r2erDBwPxap4Z1rszWnFrmbULm83YSH-1pcHZ-mdNSqFp4_0mtIR3wHvshLSBhxL_3nuwV0hRYUqjjWOZRsBiZEHi9aZMVTm4dWsQlTJAHqQV1igwayn59d0TKmLSgDMvKxQU59SjBeXjVVia05IK7h6zJQ5GmjpzQmbOVpgig3_fxsuDP5-DXyteXKkLbLU23L_K2Pr8FgiJ_KlG2JpIoUB3DcR_tm-vmtUv-dB6ndqPC4RFgzt_4MCzZdzf-9cE5v0XwDxvKpNvZk-UOvTn6bqFdIChJ_1s8WaA"
    @private_key """
      -----BEGIN RSA PRIVATE KEY-----
      MIIEogIBAAKCAQEAnzyis1ZjfNB0bBgKFMSvvkTtwlvBsaJq7S5wA+kzeVOVpVWw
      kWdVha4s38XM/pa/yr47av7+z3VTmvDRyAHcaT92whREFpLv9cj5lTeJSibyr/Mr
      m/YtjCZVWgaOYIhwrXwKLqPr/11inWsAkfIytvHWTxZYEcXLgAXFuUuaS3uF9gEi
      NQwzGTU1v0FqkqTBr4B8nW3HCN47XUu0t8Y0e+lf4s4OxQawWD79J9/5d3Ry0vbV
      3Am1FtGJiJvOwRsIfVChDpYStTcHTCMqtvWbV6L11BWkpzGXSW4Hv43qa+GSYOD2
      QU68Mb59oSk2OB+BtOLpJofmbGEGgvmwyCI9MwIDAQABAoIBACiARq2wkltjtcjs
      kFvZ7w1JAORHbEufEO1Eu27zOIlqbgyAcAl7q+/1bip4Z/x1IVES84/yTaM8p0go
      amMhvgry/mS8vNi1BN2SAZEnb/7xSxbflb70bX9RHLJqKnp5GZe2jexw+wyXlwaM
      +bclUCrh9e1ltH7IvUrRrQnFJfh+is1fRon9Co9Li0GwoN0x0byrrngU8Ak3Y6D9
      D8GjQA4Elm94ST3izJv8iCOLSDBmzsPsXfcCUZfmTfZ5DbUDMbMxRnSo3nQeoKGC
      0Lj9FkWcfmLcpGlSXTO+Ww1L7EGq+PT3NtRae1FZPwjddQ1/4V905kyQFLamAA5Y
      lSpE2wkCgYEAy1OPLQcZt4NQnQzPz2SBJqQN2P5u3vXl+zNVKP8w4eBv0vWuJJF+
      hkGNnSxXQrTkvDOIUddSKOzHHgSg4nY6K02ecyT0PPm/UZvtRpWrnBjcEVtHEJNp
      bU9pLD5iZ0J9sbzPU/LxPmuAP2Bs8JmTn6aFRspFrP7W0s1Nmk2jsm0CgYEAyH0X
      +jpoqxj4efZfkUrg5GbSEhf+dZglf0tTOA5bVg8IYwtmNk/pniLG/zI7c+GlTc9B
      BwfMr59EzBq/eFMI7+LgXaVUsM/sS4Ry+yeK6SJx/otIMWtDfqxsLD8CPMCRvecC
      2Pip4uSgrl0MOebl9XKp57GoaUWRWRHqwV4Y6h8CgYAZhI4mh4qZtnhKjY4TKDjx
      QYufXSdLAi9v3FxmvchDwOgn4L+PRVdMwDNms2bsL0m5uPn104EzM6w1vzz1zwKz
      5pTpPI0OjgWN13Tq8+PKvm/4Ga2MjgOgPWQkslulO/oMcXbPwWC3hcRdr9tcQtn9
      Imf9n2spL/6EDFId+Hp/7QKBgAqlWdiXsWckdE1Fn91/NGHsc8syKvjjk1onDcw0
      NvVi5vcba9oGdElJX3e9mxqUKMrw7msJJv1MX8LWyMQC5L6YNYHDfbPF1q5L4i8j
      8mRex97UVokJQRRA452V2vCO6S5ETgpnad36de3MUxHgCOX3qL382Qx9/THVmbma
      3YfRAoGAUxL/Eu5yvMK8SAt/dJK6FedngcM3JEFNplmtLYVLWhkIlNRGDwkg3I5K
      y18Ae9n7dHVueyslrb6weq7dTkYDi3iOYRW8HRkIQh06wEdbxt0shTzAJvvCQfrB
      jg/3747WSsf/zBTcHihTRBdAv6OmdhV4/dD5YBfLAkLrd+mX7iE=
      -----END RSA PRIVATE KEY-----
      """

    test "sign/2" do
      assert {:ok, @jwt} = JOSE.sign(%JWT{header: @header, payload: @payload}, @private_key, json_library: Jason)
    end

    test "verify/3" do
      {:ok, jwt} = JOSE.decode(@jwt, json_library: Jason)

      assert JOSE.verify(jwt, @private_key, [])
    end
  end
end
