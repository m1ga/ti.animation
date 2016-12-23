/* C++ code produced by gperf version 3.0.4 */
/* Command-line: gperf -L C++ -E -t /tmp/miga/ti.keyframes-generated/KrollGeneratedBindings.gperf  */
/* Computed positions: -k'' */

#line 3 "/tmp/miga/ti.keyframes-generated/KrollGeneratedBindings.gperf"


#include <string.h>
#include <v8.h>
#include <KrollBindings.h>

#include "ti.keyframes.KeyframesProxy.h"
#include "ti.keyframes.TiKeyframesModule.h"


#line 14 "/tmp/miga/ti.keyframes-generated/KrollGeneratedBindings.gperf"
struct titanium::bindings::BindEntry;
/* maximum key range = 4, duplicates = 0 */

class TiKeyframesBindings
{
private:
  static inline unsigned int hash (const char *str, unsigned int len);
public:
  static struct titanium::bindings::BindEntry *lookupGeneratedInit (const char *str, unsigned int len);
};

inline /*ARGSUSED*/
unsigned int
TiKeyframesBindings::hash (register const char *str, register unsigned int len)
{
  return len;
}

struct titanium::bindings::BindEntry *
TiKeyframesBindings::lookupGeneratedInit (register const char *str, register unsigned int len)
{
  enum
    {
      TOTAL_KEYWORDS = 2,
      MIN_WORD_LENGTH = 27,
      MAX_WORD_LENGTH = 30,
      MIN_HASH_VALUE = 27,
      MAX_HASH_VALUE = 30
    };

  static struct titanium::bindings::BindEntry wordlist[] =
    {
      {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""},
      {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""},
      {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""}, {""},
#line 16 "/tmp/miga/ti.keyframes-generated/KrollGeneratedBindings.gperf"
      {"ti.keyframes.KeyframesProxy", ::ti::keyframes::tikeyframes::KeyframesProxy::bindProxy, ::ti::keyframes::tikeyframes::KeyframesProxy::dispose},
      {""}, {""},
#line 17 "/tmp/miga/ti.keyframes-generated/KrollGeneratedBindings.gperf"
      {"ti.keyframes.TiKeyframesModule", ::ti::keyframes::TiKeyframesModule::bindProxy, ::ti::keyframes::TiKeyframesModule::dispose}
    };

  if (len <= MAX_WORD_LENGTH && len >= MIN_WORD_LENGTH)
    {
      register int key = hash (str, len);

      if (key <= MAX_HASH_VALUE && key >= 0)
        {
          register const char *s = wordlist[key].name;

          if (*str == *s && !strcmp (str + 1, s + 1))
            return &wordlist[key];
        }
    }
  return 0;
}
#line 18 "/tmp/miga/ti.keyframes-generated/KrollGeneratedBindings.gperf"

