import { forwardRef, InputHTMLAttributes } from 'react';
import { cn } from '@/lib/utils';

export interface InputProps extends InputHTMLAttributes<HTMLInputElement> {}

const Input = forwardRef<HTMLInputElement, InputProps>(
  ({ className, type, ...props }, ref) => {
    return (
      <input
        type={type}
        className={cn(
          'flex h-11 w-full rounded-xl px-3 py-2 text-sm transition-all duration-200',
          'placeholder:text-text-tertiary',
          'focus:outline-none focus:ring-1',
          'disabled:cursor-not-allowed disabled:opacity-50',
          className
        )}
        style={{
          background: 'var(--color-surface-3)',
          color: 'var(--color-text-primary)',
          border: '1px solid var(--color-border)',
        }}
        ref={ref}
        {...props}
      />
    );
  }
);

Input.displayName = 'Input';

export { Input };
