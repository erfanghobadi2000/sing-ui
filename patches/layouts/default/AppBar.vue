<template>
  <v-app-bar
    flat
    class="sing-ui-topbar"
    height="70"
  >
    <v-btn
      v-if="isMobile"
      icon="mdi-menu"
      variant="text"
      @click="$emit('toggleDrawer')"
    />
    <div class="sing-ui-topbar-title">
      <div class="sing-ui-kicker">Sing-UI</div>
      <div class="sing-ui-page">{{ $t(<string>route.name) }}</div>
    </div>

    <v-spacer />

    <v-chip
      v-if="maintenance"
      size="small"
      class="mr-2"
      color="warning"
      variant="tonal"
      prepend-icon="mdi-wrench"
    >
      {{ $t('setting.maintenance') }}
    </v-chip>

    <v-btn icon="mdi-translate" variant="text" class="top-action">
      <v-menu activator="parent">
        <v-list density="compact">
          <v-list-item
            v-for="lang in languages"
            :key="lang.value"
            :active="isActiveLocale(lang.value)"
            @click="changeLocale(lang.value)"
          >
            <v-list-item-title>{{ lang.title }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-btn>

    <v-btn icon="mdi-theme-light-dark" variant="text" class="top-action">
      <v-menu activator="parent">
        <v-list density="compact">
          <v-list-item
            v-for="th in themes"
            :key="th.value"
            :prepend-icon="th.icon"
            :active="isActiveTheme(th.value)"
            @click="changeTheme(th.value)"
          >
            <v-list-item-title>{{ $t(`theme.${th.value}`) }}</v-list-item-title>
          </v-list-item>
        </v-list>
      </v-menu>
    </v-btn>
  </v-app-bar>
</template>

<script lang="ts" setup>
import { useLocale } from 'vuetify'
import { useRoute } from 'vue-router'
import { useI18n } from 'vue-i18n'
import { languages } from '@/locales'
import { useThemeSwitcher } from '@/composables/useThemeSwitcher'
import { computed } from 'vue'
import Data from '@/store/modules/data'

defineProps<{ isMobile: boolean }>()
defineEmits<{ toggleDrawer: [] }>()

const route = useRoute()
const { locale: i18nLocale } = useI18n()
const vuetifyLocale = useLocale()
const { themes, changeTheme, isActiveTheme } = useThemeSwitcher()

const changeLocale = (l: string) => {
  i18nLocale.value = l
  vuetifyLocale.current.value = l
  localStorage.setItem('locale', l)
  window.location.reload()
}
const isActiveLocale = (l: string) => i18nLocale.value === l
const maintenance = computed(() => Data().maintenance)
</script>
