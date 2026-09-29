<template>
  <v-container class="sing-ui-login fill-height">
    <div class="sing-ui-login-glow sing-ui-login-glow-a" />
    <div class="sing-ui-login-glow sing-ui-login-glow-b" />
    <v-card class="sing-ui-login-card" elevation="0">
      <div class="sing-ui-login-brand">
        <div class="sing-ui-brand-mark sing-ui-login-mark">S</div>
        <div>
          <div class="sing-ui-login-kicker">Sing-Box Control Panel</div>
          <h1>Sing-UI</h1>
        </div>
      </div>

      <v-card-title class="px-0 pt-0">{{ $t('login.title') }}</v-card-title>
      <v-card-text class="px-0">
        <v-form ref="form" @submit.prevent="login">
          <v-text-field
            v-model="username"
            :label="$t('login.username')"
            :rules="usernameRules"
            prepend-inner-icon="mdi-account-outline"
            autocomplete="username"
            required
          />
          <v-text-field
            v-model="password"
            :label="$t('login.password')"
            :rules="passwordRules"
            type="password"
            prepend-inner-icon="mdi-lock-outline"
            autocomplete="current-password"
            required
          />
          <v-btn
            :loading="loading"
            type="submit"
            color="primary"
            size="large"
            block
            class="sing-ui-login-submit mt-2"
          >
            {{ $t('actions.submit') }}
          </v-btn>
        </v-form>

        <div class="sing-ui-login-tools">
          <v-select
            v-model="$i18n.locale"
            density="compact"
            hide-details
            variant="solo-filled"
            :items="languages"
            @update:model-value="changeLocale"
          >
            <template #prepend-inner>
              <v-icon icon="mdi-translate" />
            </template>
          </v-select>
          <v-menu>
            <template #activator="{ props }">
              <v-btn icon="mdi-theme-light-dark" variant="tonal" v-bind="props" />
            </template>
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
        </div>
      </v-card-text>
    </v-card>
  </v-container>
</template>

<script lang="ts" setup>
import { ref } from 'vue'
import { useLocale } from 'vuetify'
import { i18n, languages } from '@/locales'
import { useRouter } from 'vue-router'
import HttpUtil from '@/plugins/httputil'
import { setAuthenticated } from '@/plugins/auth'
import { useThemeSwitcher } from '@/composables/useThemeSwitcher'

const locale = useLocale()
const { themes, changeTheme, isActiveTheme } = useThemeSwitcher()

const username = ref('')
const usernameRules = [(value: string) => value?.length > 0 ? true : i18n.global.t('login.unRules')]

const password = ref('')
const passwordRules = [(value: string) => value?.length > 0 ? true : i18n.global.t('login.pwRules')]

const loading = ref(false)
const router = useRouter()

const login = async () => {
  if (username.value === '' || password.value === '') return
  loading.value = true
  const response = await HttpUtil.post('api/login', { user: username.value, pass: password.value })
  if (response.success) {
    setAuthenticated()
    setTimeout(() => {
      loading.value = false
      router.push('/')
    }, 350)
  } else {
    loading.value = false
  }
}

const changeLocale = (l: string | null) => {
  locale.current.value = l ?? 'en'
  localStorage.setItem('locale', locale.current.value)
}
</script>
