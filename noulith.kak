# http://noulith.org
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

# Detection
# ‾‾‾‾‾‾‾‾‾

hook global BufCreate .*[.](noul) %{
    set-option buffer filetype noulith
}

# Initialization
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾

hook global WinSetOption filetype=noulith %{
    require-module noulith

    set-option window static_words %opt{noulith_static_words}

    hook window InsertChar \n -group noulith-insert noulith-insert-on-new-line
    hook window InsertChar \n -group noulith-indent noulith-indent-on-new-line
    # cleanup trailing whitespaces on current line insert end
    hook window ModeChange pop:insert:.* -group noulith-trim-indent %{ try %{ execute-keys -draft <semicolon> x s ^\h+$ <ret> d } }
    hook -once -always window WinSetOption filetype=.* %{ remove-hooks window noulith-.+ }
}

hook -group noulith-highlight global WinSetOption filetype=noulith %{
    add-highlighter window/noulith ref noulith
    hook -once -always window WinSetOption filetype=.* %{ remove-highlighter window/noulith }
}

provide-module noulith %§

# Highlighters & Completion
# ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾

add-highlighter shared/noulith regions
add-highlighter shared/noulith/code default-region group
add-highlighter shared/noulith/docstring     region -match-capture ^\h*("""|''') (?<!\\)(?:\\\\)*("""|''') regions
add-highlighter shared/noulith/triple_string region -match-capture ("""|''') (?<!\\)(?:\\\\)*("""|''') fill string
add-highlighter shared/noulith/double_string region '"'   (?<!\\)(\\\\)*"  fill string
add-highlighter shared/noulith/single_string region "'"   (?<!\\)(\\\\)*'  fill string
add-highlighter shared/noulith/documentation region '##'  '$'              fill documentation
add-highlighter shared/noulith/comment       region '#'   '$'              fill comment

# Integer formats
add-highlighter shared/noulith/code/ regex '(?i)\b0b[01]+l?\b' 0:value
add-highlighter shared/noulith/code/ regex '(?i)\b0x[\da-f]+l?\b' 0:value
add-highlighter shared/noulith/code/ regex '(?i)\b0o?[0-7]+l?\b' 0:value
add-highlighter shared/noulith/code/ regex '(?i)\b([1-9]\d*|0)l?\b' 0:value
# Float formats
add-highlighter shared/noulith/code/ regex '\b\d+[eE][+-]?\d+\b' 0:value
add-highlighter shared/noulith/code/ regex '(\b\d+)?\.\d+\b' 0:value
add-highlighter shared/noulith/code/ regex '\b\d+\.' 0:value
# Imaginary formats
add-highlighter shared/noulith/code/ regex '\b\d+\+\d+[jJ]\b' 0:value

add-highlighter shared/noulith/docstring/ default-region fill documentation
add-highlighter shared/noulith/docstring/ region '(>>>|\.\.\.) \K'    (?=''')|(?=""") ref noulith

evaluate-commands %sh{
    # Grammar
    # values="True False None self inf"
    # meta="import from"

    # attributes and methods list based on https://docs.noulith.org/3/reference/datamodel.html

    # built-in exceptions https://docs.noulith.org/3/library/exceptions.html

    # Keyword list is collected using `keyword.kwlist` from `keyword`
    keywords="! if else while for yield into switch case null and or coalesce break try catch throw continue return consume pop remove swap every struct freeze import literally R F V"

    # Collected from `keyword.softkwlist`

    # types="bool buffer bytearray bytes complex dict file float frozenset int
    #        list long memoryview object set str tuple unicode xrange"

    functions="abs acos acosh aes128_hazmat_decrypt_block aes128_hazmat_encrypt_block aes256_gcm_decrypt aes256_gcm_encrypt all and any anything append append_file apply asin asinh assert atan atan2 atanh base64decode base64encode blake3 butlast by bytes cbrt ceil chr combinations complex complex_parts const contains cos cosh count cycle debug default denominator dict discard drop each echo ends_with enumerate eval even exp factorize false filter find map find? first flat_map flatten flip float floor flush fold frequencies from func gcd group hex_decode hex_encode id imag_part in index index? input insert int int_radix interact iota is is_alnum is_alpha is_ascii is_digit is_lower is_prime is_space is_upper items iterate join json_decode json_encode keys last len lines list ln locate locate? log10 log2 lower map map_keys map_values max md5 memoize merge min not not_in now nulltype number numerator odd of on only or ord pairwise partition permutations prefixes print product random random_bytes random_range rational read read_file read_file? read_file_bytes read_file_bytes? real_part reject repeat replace request reverse round satisfying scan search search_all second set sha256 signum sin sinh sleep sort split sqrt starts_with str str_radix stream strip subsequences subtract suffixes sum tail take tan tanh then third til time to transpose trim true type uncons uncons? unique unlines unsnoc unsnoc? unwords upper utf8decode utf8encode values vars vector window with words write write_file xor zip ziplongest"

    join() { sep=$2; eval set -- $1; IFS="$sep"; echo "$*"; }

    # Add the language's grammar to the static completion list
    # printf %s\\n "declare-option str-list noulith_static_words $(join "${values} ${meta} ${attributes} ${methods} ${exceptions} ${keywords} ${types} ${functions}" ' ')"
    printf %s\\n "declare-option str-list noulith_static_words $(join "${keywords} ${functions}" ' ')"

    # Highlight keywords
    printf %s "
        add-highlighter shared/noulith/code/ regex '\b($(join "${keywords}" '|'))\b' 0:keyword
        add-highlighter shared/noulith/code/ regex '\b($(join "${functions}" '|'))\b' 1:function
    "
}

add-highlighter shared/noulith/code/ regex (?<=[\w\s\d\)\]'"_])(<=|<<|>>|>=|<>?|>|!=|==|\||\^|&|\+|-|\*\*?|//?|%|~) 0:operator
add-highlighter shared/noulith/code/ regex (?<=[\w\s\d'"_])((?<![=<>!]):?=(?![=])|[+*-]=) 0:builtin
add-highlighter shared/noulith/code/ regex ^\h*(?:from|import)\h+(\S+) 1:module

hook global BufSetOption filetype=noulith %{
    set-option buffer comment_line '#'
}


# Commands
# ‾‾‾‾‾‾‾‾

define-command -hidden noulith-insert-on-new-line %{
    evaluate-commands -draft -itersel %{
        # copy '#' comment prefix and following white spaces
        try %{ execute-keys -draft k x s ^\h*#\h* <ret> y jgh P }
    }
}

define-command -hidden noulith-indent-on-new-line %<
    evaluate-commands -draft -itersel %<
        # preserve previous line indent
        try %{ execute-keys -draft <semicolon> K <a-&> }
        # cleanup trailing whitespaces from previous line
        try %{ execute-keys -draft k x s \h+$ <ret> d }
        # indent after line ending with :
        try %{ execute-keys -draft , k x <a-k> :$ <ret> <a-K> ^\h*# <ret> j <a-gt> }
        # deindent closing brace/bracket when after cursor (for arrays and dictionaries)
        try %< execute-keys -draft x <a-k> ^\h*[}\]] <ret> gh / [}\]] <ret> m <a-S> 1<a-&> >
    >
>

§
