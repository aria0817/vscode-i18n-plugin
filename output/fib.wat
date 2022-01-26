(module
  (type (;0;) (func))
  (type (;1;) (func (param i32) (result i32)))
  (func (;0;) (type 0)
    nop)
  (func (;1;) (type 1) (param i32) (result i32)
    (local i32)
    local.get 0
    i32.const 0
    i32.le_s
    if  ;; label = @1
      i32.const 0
      return
    end
    local.get 0
    i32.const 3
    i32.ge_u
    if  ;; label = @1
      loop  ;; label = @2
        local.get 0
        i32.const 2
        i32.sub
        call 1
        local.get 1
        i32.add
        local.set 1
        local.get 0
        i32.const 1
        i32.sub
        local.tee 0
        i32.const 2
        i32.gt_u
        br_if 0 (;@2;)
      end
    end
    local.get 1
    i32.const 1
    i32.add)
  (export "__wasm_call_ctors" (func 0))
  (export "fib" (func 1)))
